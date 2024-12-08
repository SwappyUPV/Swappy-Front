import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
    super.key,
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
        ],
      ),
    );
  }
}
