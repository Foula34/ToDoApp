import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  Future<File?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    return photo != null ? File(photo.path) : null;
  }
}
