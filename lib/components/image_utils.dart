import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageUtils {
  static Future<File?> pickAlbumImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      File? croppedFile = await cropImage(File(result.files.single.path!));
      return croppedFile;
    } else {
      // User canceled the picker
      return null;
    }
  }

  static Future<File?> cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }
}
