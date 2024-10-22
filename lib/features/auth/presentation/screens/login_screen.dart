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
    _autoLogin();
  }

  Future<String> _loginUser(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  void _autoLogin() async {
    String email = 's@gmail.com';
    String password = '123456';

    String res = await _loginUser(email: email, password: password);

    if (res == 'success') {
      // Actualizar el índice del NavigationMenu para mostrar el Catálogo
      navigationController.updateIndex(0);

      // Eliminar todas las rutas anteriores y mostrar el NavigationMenu
      Get.offAll(() => NavigationMenu());
    } else {
      Get.snackbar(
        'Error',
        'Error en inicio de sesión automático: $res',
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
          mobile: MobileLogin(),
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
  const MobileLogin({
    super.key,
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
