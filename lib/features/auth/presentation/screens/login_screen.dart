import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pin/core/utils/NavigationMenu/NavigationMenu.dart';
import '../widgets/forms/login_form.dart';
import 'package:pin/core/utils/NavigationMenu/controllers/navigationController.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NavigationController navigationController =
      Get.find<NavigationController>();
  bool _isHoveredCatalogue = false;

  Future<String> _loginUser(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  void _navigateToCatalogue() {
    navigationController.updateIndex(0);
    Get.offAll(() => NavigationMenu());
  }

  void _handleLogin(String email, String password) async {
    String res = await _loginUser(email: email, password: password);
    if (res == 'success') {
      _navigateToCatalogue();
    } else {
      Get.snackbar(
        'Error',
        'Error en inicio de sesión: $res',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final horizontalPadding = isMobile ? 20.0 : 50.0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: isMobile ? 50 : 75),
                  // Top Logo and Back Button
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Volver al catálogo button
                        MouseRegion(
                          onEnter: (_) =>
                              setState(() => _isHoveredCatalogue = true),
                          onExit: (_) =>
                              setState(() => _isHoveredCatalogue = false),
                          child: TextButton(
                            onPressed: _navigateToCatalogue,
                            style: TextButton.styleFrom(
                              foregroundColor: _isHoveredCatalogue
                                  ? Colors.grey
                                  : Colors.black,
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
                  SizedBox(height: isMobile ? 100 : 172),

                  // Login Form
                  LoginForm(onLogin: _handleLogin),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
