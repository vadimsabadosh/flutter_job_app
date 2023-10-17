import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_app/constants/app_constants.dart';

import '../services/helpers/user_helper.dart';

class ImageUploader extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  List<String> imageUrl = [];

  void pickImage() async {
    XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      // Crop the image

      imageFile = await cropImage(imageFile);
      if (imageFile != null) {
        imageUrl.add(imageFile.path);
        imageUpload(imageFile);
      } else {
        return;
      }
    }
  }

  Future<XFile?> cropImage(XFile imageFile) async {
    // Crop the image using image_cropper package
    CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: imageFile.path,
      maxWidth: 1080,
      maxHeight: 1920,
      compressQuality: 80,
      aspectRatioPresets: [CropAspectRatioPreset.ratio4x3],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Color(kLightBlue.value),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      notifyListeners();
      return XFile(croppedFile.path);
    } else {
      return null;
    }
  }

  imageUpload(XFile file) async {
    String? profile = await UserHelper.uploadPhoto(file);
    if (profile != null) {
      imageUrl.add(profile);
    }
  }
}
