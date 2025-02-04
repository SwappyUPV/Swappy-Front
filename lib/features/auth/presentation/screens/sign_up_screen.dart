import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin/core/constants/constants.dart';
import 'package:pin/core/utils/NavigationMenu/NavigationMenu.dart';
import 'package:pin/core/utils/NavigationMenu/controllers/navigationController.dart';
import 'package:pin/core/utils/responsive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/forms/sign_up_form.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isHoveredCatalogue = false;
  bool _isHoveredLogin = false;

  void _navigateToCatalogue() {
    final navigationController = Get.find<NavigationController>();
    navigationController.updateIndex(0);
    Get.offAll(() => NavigationMenu());
  }

  void _navigateToLogin() {
    Get.off(() => const Login());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final horizontalPadding = isMobile ? 20.0 : 50.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: isMobile ? 50 : 75,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Volver al catálogo button
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHoveredCatalogue = true),
                    onExit: (_) => setState(() => _isHoveredCatalogue = false),
                    child: TextButton(
                      onPressed: _navigateToCatalogue,
                      style: TextButton.styleFrom(
                        foregroundColor:
                            _isHoveredCatalogue ? Colors.grey : Colors.black,
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: isMobile ? 18 : 20,
                            color: _isHoveredCatalogue
                                ? Colors.grey
                                : Colors.black,
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
                  ),

                  // Logo
                  SvgPicture.asset(
                    'assets/icons/logo.svg',
                    height: isMobile ? 17 : 35,
                  ),
                ],
              ),
            ),
            Responsive(
              mobile: Column(
                children: [
                  const SignUpForm(),
                  _buildLoginLink(),
                ],
              ),
              desktop: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 450,
                          child: Column(
                            children: [
                              const SignUpForm(),
                              _buildLoginLink(),
                            ],
                          ),
                        ),
                        const SizedBox(height: defaultPadding / 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHoveredLogin = true),
        onExit: (_) => setState(() => _isHoveredLogin = false),
        child: GestureDetector(
          onTap: _navigateToLogin,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color:
                      _isHoveredLogin ? Colors.grey : const Color(0xFF000000),
                  fontFamily: 'UrbaneLight',
                  fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 15,
                  letterSpacing: -0.26,
                ),
                children: [
                  TextSpan(text: '¿Ya tienes una cuenta? '),
                  TextSpan(
                    text: 'Inicia sesión aquí',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
