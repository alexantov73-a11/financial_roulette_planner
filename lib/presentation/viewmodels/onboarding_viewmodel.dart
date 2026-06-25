import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/services/storage_service.dart';
import '../../data/models/user_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  final StorageService _storageService;

  OnboardingViewModel(this._storageService);

  Future<void> completeOnboarding() async {
    try {
      final user = UserModel(
        id: const Uuid().v4(),
        name: null,
        photoPath: null,
        onboardingCompleted: true,
        createdAt: DateTime.now(),
      );

      await _storageService.saveUser(user);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
