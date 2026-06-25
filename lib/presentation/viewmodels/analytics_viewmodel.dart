import 'package:flutter/material.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/analytics_service.dart';
import '../../data/models/analytics_model.dart';

class AnalyticsViewModel extends ChangeNotifier {
  final StorageService _storageService;
  final AnalyticsService _analyticsService = AnalyticsService();

  AnalyticsModel _analytics = AnalyticsModel.empty();

  AnalyticsViewModel(this._storageService);

  AnalyticsModel get analytics => _analytics;

  Future<void> loadAnalytics() async {
    final goals = _storageService.getGoals();
    _analytics = _analyticsService.calculateAnalytics(goals);
    notifyListeners();
  }
}
