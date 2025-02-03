import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class ImagePickerWidget extends StatelessWidget {
  final dynamic pickedImage;
  final Function(dynamic) onImagePicked;

  // Dimensiones estándar para todas las imágenes
  static const double STANDARD_WIDTH = 800.0;
  static const double STANDARD_HEIGHT = 1200.0;
  static const int IMAGE_QUALITY = 85;

  // Dimensiones de visualización
  static const double DISPLAY_WIDTH = 400.0;
  static const double DISPLAY_HEIGHT = 650.0;

  const ImagePickerWidget({
    super.key,
    required this.pickedImage,
    required this.onImagePicked,
  });

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: STANDARD_WIDTH,
        maxHeight: STANDARD_HEIGHT,
        imageQuality: IMAGE_QUALITY,
      );
      if (pickedFile != null) {
        if (kIsWeb) {
          onImagePicked(pickedFile);
        } else {
          onImagePicked(File(pickedFile.path));
        }
      }
    } catch (e) {
      print('Error selecting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sidePadding = screenWidth * 0.1; // 10% del ancho de la pantalla

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sidePadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.add, size: 24),
                label: const Text(
                  'Sube una foto',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontFamily: 'OpenSans',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              );
            },
          ),
        ),
        if (pickedImage != null)
          Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: sidePadding),
            child: Container(
              width: DISPLAY_WIDTH,
              height: DISPLAY_HEIGHT,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb
                      ? Image.network(
                          pickedImage.path,
                          width: DISPLAY_WIDTH,
                          height: null, // Altura automática
                          fit: BoxFit.fitWidth, // Ajustar al ancho
                        )
                      : Image.file(
                          pickedImage,
                          width: DISPLAY_WIDTH,
                          height: null, // Altura automática
                          fit: BoxFit.fitWidth, // Ajustar al ancho
                        ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
