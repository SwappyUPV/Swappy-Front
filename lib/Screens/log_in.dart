import 'package:flutter/material.dart';
import 'package:pin/components/responsive.dart';
import 'package:pin/Screens/catalogue.dart';
import 'package:pin/Services/authentication.dart';

import '../components/background.dart';
import '../components/login/login_form.dart';
import '../components/login/login_screen_top_image.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthMethod _authMethod = AuthMethod();

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  void _autoLogin() async {
    String email = 's@gmail.com';
    String password = '123456';

    String res = await _authMethod.loginUser(
      email: email,
      password: password,
    );

    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Catalogue()),
      );
    } else {
      // Si el inicio de sesión automático falla, muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error en inicio de sesión automático: $res'),
          backgroundColor: Colors.red,
        ),
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
