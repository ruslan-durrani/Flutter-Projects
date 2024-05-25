import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mental_healthapp/shared/utils/show_snackbar.dart';

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    image = pickedImage != null ? File(pickedImage.path) : null;
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}
