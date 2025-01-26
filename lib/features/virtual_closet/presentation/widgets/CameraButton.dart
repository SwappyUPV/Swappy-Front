import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  const CameraButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Positioned(
      top: 20,
      left: 20,
      child: Icon(
        Icons.add_a_photo,
        size: 24,
        color: Colors.black,
      ),
    );
  }
}