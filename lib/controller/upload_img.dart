import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadImg {
  final ImagePicker imagePicker = ImagePicker();
  final sendApi = GetConnect();

  Future<String> pickImage() async {
    final PickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      return PickedFile.path;
    } else {
      return "no image has picked";
    }
  }

  Future<String> uploadImage(String imagePath) async {
    final File? imgFile = File(imagePath);
    if (imgFile == null) {
      return "no imagef found";
    }
    final cloudUrl = "https://api.cloudinary.com/v1_1/dhzgzeoqe/image/upload";
    final ImageData = MultipartFile(
      imgFile,
      filename: imagePath.split("/").last,
    );
    Response res = await sendApi.post(
      cloudUrl,
      FormData({"upload_preset": "cardyPic", "file": ImageData}),
    );
    return res.body["secure_url"] ?? "error";
  }
}
