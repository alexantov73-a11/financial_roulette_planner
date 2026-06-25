import 'package:flutter/material.dart';
import '../../data/services/storage_service.dart';
import '../../data/models/goal_model.dart';
import '../../data/services/analytics_service.dart';
import '../../data/models/analytics_model.dart';
import '../../data/services/notification_service.dart'; // ← ДОБАВЬ ЭТО

class HomeViewModel extends ChangeNotifier {
  final StorageService _storageService;
  final AnalyticsService _analyticsService = AnalyticsService();

  List<GoalModel> _goals = [];
  AnalyticsModel _analytics = AnalyticsModel.empty();

  HomeViewModel(this._storageService);

  List<GoalModel> get goals => _goals;
  AnalyticsModel get analytics => _analytics;

  Future<void> loadData() async {
    _goals = _storageService.getGoals();
    _analytics = _analyticsService.calculateAnalytics(_goals);
    notifyListeners();
  }

  Future<void> scheduleGoalReminder() async {
    final notificationService = NotificationService();

    // Каждый понедельник в 9:00 AM
    await notificationService.scheduleWeeklyReminder(
      id: 100,
      title: '📋 Goals Check-in',
      body: "Don't forget to update your financial goals!",
      dayOfWeek: 1, // Monday
      hour: 9,
      minute: 0,
    );
  }

  Future<void> deleteGoal(String goalId) async {
    _goals.removeWhere((g) => g.id == goalId);
    await _storageService.saveGoals(_goals);
    _analytics = _analyticsService.calculateAnalytics(_goals);
    notifyListeners();
  }
}
