import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import for handling SVG images
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pin/Services/authentication.dart'; // Your AuthMethod class
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';
import '../../Home/home_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final AuthMethod _authMethod = AuthMethod();
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  @override
  void initState() {
    super.initState();
    _signInSilently();  // Try to sign in silently when the app starts
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

      setState(() {
        _isLoading = false;
      });

      if (res == 'success') {
        // Clear the loggedOut flag after successful login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('loggedOut', false);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false, // This removes all previous routes
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

  // Google Sign-In Silently Method (in case previously signed in)
  void _signInSilently() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedOut = prefs.getBool('loggedOut') ?? false; // Default is false (not logged out)

    // Only try silent sign-in if the user has not explicitly logged out
    if (!loggedOut) {
      try {
        var userCredential = await _authMethod.signInWithGoogleSilently();
        if (userCredential != null) {
          // Navigate to the HomeScreen if the user is already signed in
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false, // This removes all previous routes
          );
        }
      } catch (e) {
        print('Silent sign-in failed: $e');
      }
    } else {
      print('User has logged out, skipping silent sign-in.');
    }
  }

  // Manual Google Sign-In Method (if the user is not already signed in)
  void signInWithGoogle() async {
    try {
      // Disconnect to clear any cached Google account
      await _googleSignIn.disconnect();

      // Proceed with Google sign-in after disconnecting
      var userCredential = await _authMethod.signInWithGoogle();
      if (userCredential != null) {
        // Clear the loggedOut flag after successful login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('loggedOut', false);

        // If sign-in is successful, navigate to HomeScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false, // This removes all previous routes
        );
      }
    } catch (e) {
      print('Manual sign-in failed: $e');
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
                    return const SignUpScreen();
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
                onPressed: signInWithGoogle,  // Manual sign-in button press
              ),
            ),
          ),
        ],
      ),
    );
  }
}
