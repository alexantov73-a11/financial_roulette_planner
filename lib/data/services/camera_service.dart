import 'package:image_picker/image_picker.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<void> init() async {}

  Future<String?> pickImageFromCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    return image?.path;
  }

  Future<String?> pickImageFromGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }
}
