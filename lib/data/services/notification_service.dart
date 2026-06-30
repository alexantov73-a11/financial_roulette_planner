import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings
    iosInitializationSettings = DarwinInitializationSettings(
      // Не питаємо пермішен тут автоматично — робимо це вручну через
      // requestNotificationPermission(), щоб контролювати UX (редірект і т.д.)
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Повертає true, якщо нотифікації дозволені.
  /// На Android — завжди true (до 13 включно permission не потрібен,
  /// а на 13+ permission_handler сам відобразить системний попап при request).
  Future<bool> areNotificationsEnabled() async {
    if (Platform.isIOS) {
      final status = await Permission.notification.status;
      return status.isGranted;
    } else {
      final status = await Permission.notification.status;
      return status.isGranted || status.isLimited;
    }
  }

  /// Логіка вмикання нотифікацій:
  /// - якщо permission ще не запитувався -> показуємо системний поп-ап
  /// - якщо permission вже відхилений раніше (permanentlyDenied) ->
  ///   редіректимо в налаштування застосунку
  /// Повертає true, якщо нотифікації в результаті увімкнені.
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (status.isPermanentlyDenied || status.isRestricted) {
      // Юзер вже реджектив раніше (або обмежено системою) —
      // повторний системний поп-ап ОС вже не покаже, тож ведемо в Settings
      await openAppSettings();
      return false;
    }

    // Перший запит — показуємо стандартний системний поп-ап (і iOS, і Android 13+)
    final result = await Permission.notification.request();
    return result.isGranted || result.isLimited;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'financial_channel',
          'Financial Notifications',
          channelDescription: 'Notifications for financial goals and roulette',
          importance: Importance.max,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> scheduleWeeklyReminder({
    required int id,
    required String title,
    required String body,
    required int dayOfWeek,
    required int hour,
    required int minute,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'financial_channel',
          'Financial Notifications',
          channelDescription: 'Notifications for financial goals and roulette',
          importance: Importance.max,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfWeekday(dayOfWeek, hour, minute),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  tz.TZDateTime _nextInstanceOfWeekday(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + 1,
      hour,
      minute,
    );

    while (scheduledDate.weekday != weekday) {
      scheduledDate = tz.TZDateTime(
        tz.local,
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day + 1,
        hour,
        minute,
      );
    }

    return scheduledDate;
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
