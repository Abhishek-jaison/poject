import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final Function(String) onImagePicked;

  ImagePickerWidget({required this.onImagePicked});

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      onImagePicked(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: pickImage,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(
          0xFFE6BFFF,
        ), // Change this to your preferred color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Smaller radius
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ), // Adjust padding
      ),
      child: Text(
        "Add Image",
        style: TextStyle(
          fontSize: 16,
          color: const Color.fromARGB(255, 255, 255, 255),
        ), // Adjust text color
      ),
    );
  }
}
