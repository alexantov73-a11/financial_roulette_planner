import 'package:flutter/material.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/camera_service.dart';

class ProfileEditViewModel extends ChangeNotifier {
  final StorageService _storageService;
  final CameraService _cameraService;

  String _name = '';
  String _photoPath = '';
  bool _isLoading = false;

  ProfileEditViewModel(this._storageService, this._cameraService);

  String get name => _name;
  String get photoPath => _photoPath;
  bool get isLoading => _isLoading;

  void setName(String value) {
    _name = value;
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

  Future<void> saveProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _storageService.getUser();
      if (user != null) {
        final updated = user.copyWith(
          name: _name.isNotEmpty ? _name : user.name,
          photoPath: _photoPath.isNotEmpty ? _photoPath : user.photoPath,
        );
        await _storageService.saveUser(updated);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _name = '';
    _photoPath = '';
    notifyListeners();
  }
}
