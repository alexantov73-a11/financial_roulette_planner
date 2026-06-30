import 'package:flutter/material.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/notification_service.dart';
import 'package:in_app_review/in_app_review.dart';

class SettingsViewModel extends ChangeNotifier {
  final StorageService _storageService;
  final NotificationService _notificationService = NotificationService();

  bool _notificationsEnabled = true;

  SettingsViewModel(this._storageService);

  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> loadSettings() async {
    _notificationsEnabled = await _notificationService
        .areNotificationsEnabled();
    notifyListeners();
  }

  Future<void> requestAppReview() async {
    try {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error requesting review: $e');
    }
  }

  Future<void> toggleNotifications(bool value) async {
    if (value) {
      final granted = await _notificationService
          .requestNotificationPermission();
      // Якщо реджектнули (або редірект в Settings) — тумблер лишається вимкненим,
      // юзер сам зможе ввімкнути після зміни дозволу в системних налаштуваннях
      _notificationsEnabled = granted;
    } else {
      _notificationsEnabled = false;
      // Опціонально: скасувати заплановані нагадування
      await _notificationService.cancelAllNotifications();
    }
    notifyListeners();
  }

  Future<void> clearAllData() async {
    try {
      await _storageService.clearAll();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
