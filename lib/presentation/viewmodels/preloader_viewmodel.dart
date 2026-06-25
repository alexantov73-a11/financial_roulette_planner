import 'package:flutter/material.dart';
import '../../data/services/storage_service.dart';

class PreloaderViewModel extends ChangeNotifier {
  final StorageService _storageService;

  PreloaderViewModel(this._storageService);

  Future<String> initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final user = _storageService.getUser();

      if (user != null && user.onboardingCompleted) {
        return '/home';
      }
      return '/onboarding';
    } catch (e) {
      return '/onboarding';
    }
  }
}
