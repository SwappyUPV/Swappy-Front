import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import for handling SVG images
import 'package:pin/core/services/authentication_service.dart'; // Your AuthMethod class
import 'package:pin/features/catalogue/presentation/widgets/navigation_menu.dart';
import '../components/already_have_an_account_acheck.dart';
import '../../../../../core/constants/constants.dart';
import '../../screens/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController =
  TextEditingController(text: 's@gmail.com');
  final TextEditingController _passwordController =
  TextEditingController(text: '123456');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final AuthMethod _authMethod = AuthMethod();

  // Method to save user ID in SharedPreferences
  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }
  // Email/Password Login Method
  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String res = await _authMethod.loginUser(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Check if the widget is still mounted before updating state
      if (!mounted) return; // Prevent setState if widget is disposed

      setState(() {
        _isLoading = false;
      });

      if (res == 'success') {
        // Get the user ID here
        String userId = _authMethod.getCurrentUser()!.uid; // Get UID from the current user

        // Save the user ID to SharedPreferences
        await saveUserId(userId);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationMenu()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

// Google Sign-In Method
  void signInWithGoogle() async {
    try {
      String res = await _authMethod.signInWithGoogle();

      // Check if the widget is still mounted before updating state
      if (!mounted) return; // Prevent setState if widget is disposed

      if (res == "success") {
        // If sign-in is successful, save user ID to SharedPreferences
        String userId = _authMethod.getCurrentUser()!.uid; // Get UID from the current user
        await saveUserId(userId);

        // Navigate to NavigationMenu
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationMenu()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('exception->$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google sign-in failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email Input Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          // Password Input Field
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),

          // Login Button
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
            onPressed: loginUser,
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),

          // Already Have an Account
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUp();
                  },
                ),
              );
            },
          ),
          const SizedBox(height: defaultPadding),

          // Google Sign-In Button
          Center(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                iconSize: 40,
                icon: SvgPicture.asset(
                  'assets/icons/icons-google.svg', // Google icon from assets
                  width: 40,
                  height: 40,
                ),
                onPressed: signInWithGoogle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
