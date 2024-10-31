import 'package:flutter/material.dart';
import 'package:pin/core/utils/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pin/features/catalogue/presentation/widgets/navigation_menu.dart';

import '../../../../core/utils/background.dart';
import '../widgets/forms/login_form.dart';
import '../widgets/components/login_screen_top_image.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NavigationController navigationController =
      Get.find<NavigationController>();

  @override
  void initState() {
    super.initState();
    // Comentamos el auto-login
    // _autoLogin();
  }

  // Future<void> _autoLogin() async {
  //   String email = 's@gmail.com'; // Reemplaza con el email predeterminado
  //   String password = '123456'; // Reemplaza con la contraseña predeterminada
  //
  //   String res = await _loginUser(email: email, password: password);
  //
  //   if (res == 'success') {
  //     _navigateToCatalogue();
  //   }
  // }

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
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLogin(onLogin: _handleLogin),
          desktop: Row(
            children: [
              Expanded(
                child: LoginScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: LoginForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLogin extends StatelessWidget {
  final Function(String, String) onLogin;

  const MobileLogin({
    super.key,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LoginScreenTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
