import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pin/core/utils/NavigationMenu/NavigationMenu.dart';
import '../widgets/forms/login_form.dart';
import 'package:pin/features/auth/presentation/screens/sign_up_screen.dart';
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
  bool _isHovered = false;

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
                  // Top Logo and Register Link
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo
                        SvgPicture.asset(
                          'assets/icons/logo.svg',
                          height: isMobile ? 17 : 35,
                        ),

                        // Register Link
                        MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              _isHovered = true;
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              _isHovered = false;
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => const SignUpScreen());
                            },
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 15), // Adjust the height as needed
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    textAlign: TextAlign.right,
                                    '¿No tienes una cuenta?\nRegístrate',
                                    style: TextStyle(
                                      color: _isHovered
                                          ? Colors.grey
                                          : const Color(0xFF000000),
                                      fontFamily: 'UrbaneLight',
                                      fontSize: isMobile ? 14 : 15,
                                      letterSpacing: -0.26,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 120 : 192),

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
