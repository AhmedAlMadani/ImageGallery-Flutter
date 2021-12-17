// ignore_for_file: file_names

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImageUploadController {
  uploadImage() async {
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );

    // if (results == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar)
    // }
  }
}
