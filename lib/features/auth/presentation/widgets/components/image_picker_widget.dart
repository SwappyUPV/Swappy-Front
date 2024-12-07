import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class ImagePickerWidget extends StatelessWidget {
  final dynamic pickedImage;
  final Function(dynamic) onImagePicked;

  const ImagePickerWidget({
    super.key,
    required this.pickedImage,
    required this.onImagePicked,
  });

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        if (kIsWeb) {
          onImagePicked(pickedFile);
        } else {
          onImagePicked(File(pickedFile.path));
        }
      }
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.black,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: const Icon(Icons.photo_library, color: Colors.white),
            onPressed: _pickImage,
          ),
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 60,
          backgroundImage: pickedImage != null
              ? (kIsWeb ? NetworkImage(pickedImage.path) : FileImage(pickedImage) as ImageProvider)
              : const AssetImage('assets/images/default_user.png'),
        ),
      ],
    );
  }
}