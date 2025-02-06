import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  final VoidCallback onBackPressed;

  const SignUpScreenTopImage({
    super.key,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.only(top: 30), // Padding en la parte superior
      child: Column(
        children: [
          const SizedBox(height: defaultPadding),
          Center(
            child: SvgPicture.asset(
              'assets/icons/logo.svg',
              height: isMobile ? 25 : 35,
            ),
          ),
          const SizedBox(height: defaultPadding),
          // Botón Volver al Catálogo
          TextButton(
            onPressed: onBackPressed,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsets.zero,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: isMobile ? 18 : 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Volver al catálogo',
                  style: TextStyle(
                    fontFamily: 'UrbaneLight',
                    fontSize: isMobile ? 14 : 15,
                    letterSpacing: -0.26,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
