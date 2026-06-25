import 'package:flutter/material.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/camera_service.dart';
import '../../data/models/goal_model.dart';

class GoalEditViewModel extends ChangeNotifier {
  final StorageService _storageService;
  final CameraService _cameraService;

  String _name = '';
  double _amount = 0;
  String _category = 'Food';
  String _photoPath = '';
  bool _isLoading = false;

  GoalEditViewModel(this._storageService, this._cameraService);

  String get name => _name;
  double get amount => _amount;
  String get category => _category;
  String get photoPath => _photoPath;
  bool get isLoading => _isLoading;

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setAmount(double value) {
    _amount = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }

  void setPhoto(String path) {
    _photoPath = path;
    notifyListeners();
  }

  Future<String?> pickFromCamera() async {
    return await _cameraService.pickImageFromCamera();
  }

  Future<String?> pickFromGallery() async {
    return await _cameraService.pickImageFromGallery();
  }

  Future<void> saveGoal() async {
    _isLoading = true;
    notifyListeners();

    try {
      final goal = GoalModel(
        name: _name,
        amount: _amount,
        category: _category,
        photoPath: _photoPath.isNotEmpty ? _photoPath : null,
      );

      final goals = _storageService.getGoals();
      goals.add(goal);
      await _storageService.saveGoals(goals);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _name = '';
    _amount = 0;
    _category = 'Food';
    _photoPath = '';
    notifyListeners();
  }
}
