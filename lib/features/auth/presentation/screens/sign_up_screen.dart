import 'package:flutter/material.dart';
import 'package:pin/core/constants/constants.dart';
import 'package:pin/core/utils/responsive.dart';
import '../widgets/components/sign_up_top_image.dart';
import '../widgets/forms/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Color de fondo, opcional
      body: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileSignup(),
          desktop: Row(
            children: [
              const Expanded(
                  child: Center(
                child: SignUpScreenTopImage(),
              )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: SignUpForm(),
                    ),
                    const SizedBox(height: defaultPadding / 2),
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

class MobileSignup extends StatelessWidget {
  const MobileSignup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SignUpScreenTopImage(),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SignUpForm(),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
