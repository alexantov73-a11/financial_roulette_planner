import 'package:flutter/material.dart';
import '../../data/services/storage_service.dart';
import '../../core/theme/app_theme.dart';

class ThemeViewModel extends ChangeNotifier {
  final StorageService _storageService;
  bool _isDarkMode = false;

  ThemeViewModel(this._storageService) {
    _isDarkMode = _storageService.isDarkMode();
  }

  bool get isDarkMode => _isDarkMode;

  Future<void> loadTheme() async {
    _isDarkMode = _storageService.isDarkMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storageService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  ThemeData getThemeData() {
    return _isDarkMode ? AppTheme.darkTheme() : AppTheme.lightTheme();
  }
}
