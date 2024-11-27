import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  final String? imageAsset; // Optional parameter for the image
  final String title; // Title
  final String subtitle; // Subtitle

  // Constructor with optional parameters for the image, title, and subtitle
  const Header({
    Key? key,
    this.imageAsset,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 15),
              child: Column(
                children: [
                  // Title aligned to the left
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title, // Use the passed title parameter
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontFamily: 'UrbaneMedium',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (imageAsset != null) // Check if an image was passed
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: SvgPicture.asset(
                    imageAsset!, // Use the image passed as a parameter
                    height: 20.0, // Optional size
                    width: 20.0,
                    semanticsLabel: 'Icon', // Accessible label
                  ),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0, left: 15),
          child: Column(
            children: [
              // Subtitle aligned to the left
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  subtitle, // Use the passed subtitle parameter
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
