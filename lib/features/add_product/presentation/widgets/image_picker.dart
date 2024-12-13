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
      print('Error selecting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sidePadding = screenWidth / 3;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sidePadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double buttonWidth = constraints.maxWidth;
              double fontSize = buttonWidth / 17;
              double iconSize = buttonWidth / 15;
              double minFontSize = 10;
              double minIconSize = 10;

              fontSize = fontSize < minFontSize ? minFontSize : fontSize;
              iconSize = iconSize < minIconSize ? minIconSize : iconSize;

              return ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.add, size: iconSize),
                label: Text(
                  'Sube una foto',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontFamily: 'OpenSans',
                    fontSize: fontSize,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    height: 1.0, // This is equivalent to line-height: normal
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: kIsWeb
                  ? Image.network(
                pickedImage.path,
                width: screenWidth - 2 * sidePadding,
                height: 200,
                fit: BoxFit.cover,
              )
                  : Image.file(
                pickedImage,
                width: screenWidth - 2 * sidePadding,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }
}