import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) {
      isLoggedIn.value = user != null;
    });
  }
}