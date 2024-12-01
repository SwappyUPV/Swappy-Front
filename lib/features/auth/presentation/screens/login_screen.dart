import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pin/core/constants/constants.dart';
import 'package:pin/core/utils/background.dart';
import 'package:pin/core/utils/NavigationMenu/NavigationMenu.dart';
import '../widgets/components/login_screen_top_image.dart';
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
  final NavigationController navigationController = Get.find<NavigationController>();

  Future<String> _loginUser({required String email, required String password}) async {
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 75),
              // Top Logo and Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  SizedBox(
                    height: 57, // Match the height of the Register text
                    child: SvgPicture.asset(
                      'assets/icons/logo.svg',
                      height: 28,
                      color: PrimaryColor,
                    ),
                  ),

                  // Register Link
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const SignUpScreen()); // Replace with your signup screen
                    },
                    child: SizedBox(
                      height: 57, // Match the height with logo container
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '¿No tienes una cuenta?\nRegístrate',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontFamily: 'UrbaneMedium',
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w300,
                            letterSpacing: -0.26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 192),

              // Login Form
              LoginForm(onLogin: _handleLogin),

            ],
          ),
        ),
      ),
    );
  }
}
