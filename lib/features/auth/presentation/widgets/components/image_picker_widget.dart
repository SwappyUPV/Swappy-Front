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
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // IconButton en la esquina inferior derecha
          Positioned(
            bottom: -10, // Ajusta el valor para solapar más o menos
            right: -29, // Ajusta el valor para solapar más o menos
            child: Ink(
              decoration: const ShapeDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.photo_library,
                    color: Color.fromARGB(255, 0, 0, 0)),
                onPressed: _pickImage,
                iconSize: 28, // Tamaño del ícono
              ),
            ),
          ),
          CircleAvatar(
            radius: 50,
            backgroundImage: pickedImage != null
                ? (kIsWeb
                    ? NetworkImage(pickedImage.path)
                    : FileImage(pickedImage) as ImageProvider)
                : const AssetImage('assets/images/default_user.png'),
          ),
        ],
      ),
    );
  }
}
