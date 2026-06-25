import 'package:flutter/material.dart';
import '../../data/services/storage_service.dart';
import 'package:in_app_review/in_app_review.dart';

class SettingsViewModel extends ChangeNotifier {
  final StorageService _storageService;

  bool _notificationsEnabled = true;

  SettingsViewModel(this._storageService);

  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> loadSettings() async {
    _notificationsEnabled = true;
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
    _notificationsEnabled = value;
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
