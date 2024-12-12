import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoContainer extends StatelessWidget {

  late final XFile? selectedImage;

  PhotoContainer({super.key, required XFile? image}) {
    selectedImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: _showImage(),
      ),
    );
  }

  Widget _showImage() {
    if (selectedImage != null) {
      return Image.file(File(selectedImage!.path));
    } else {
      return const Text('Фотография не выбрана');
    }
  }
}