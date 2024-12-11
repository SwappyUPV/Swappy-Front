import 'package:flutter/material.dart';
import '/features/add_product/presentation/widgets/image_picker.dart';

class PhotoUploadSection extends StatelessWidget {
  final dynamic pickedImage;
  final ValueChanged<dynamic> onImagePicked;

  const PhotoUploadSection({
    Key? key,
    required this.pickedImage,
    required this.onImagePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Primero, añade una foto de la prenda que vas a vender o intercambiar. ¡Asegúrate de que aparezca nítida, de frente y bien iluminada!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
        const SizedBox(height: 19),
        ImagePickerWidget(
          pickedImage: pickedImage,
          onImagePicked: onImagePicked,
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}