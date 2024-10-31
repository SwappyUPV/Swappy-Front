import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> signInWithGoogleSilently() async {
    return await _googleSignIn.signInSilently();
  }

  /*
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    return await _googleSignIn.signIn();
  }
  */
  Future<String> signInWithGoogle() async {
    String res = "Some error occurred";
    try {
      // Start Google Sign-In process
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return "Google sign-in aborted"; // User aborted the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Check if the user already exists in Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // If the user does not exist, add them to Firestore
        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
        });
      }

      res = "success";
      print(res);
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // SignUp User
  Future<String> signupUser(
      {required String email, required String password}) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // register user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // add user to your firestore database
        print(cred.user!.uid);
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'uid': cred.user!.uid,
          'email': email,
        });
        res = "success";
        print(res);
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logIn user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<bool> signOut() async {
    try {
      // Get the current Firebase user
      User? user = _auth.currentUser;

      if (user != null) {
        // Loop through providerData to check how the user signed in
        for (var provider in user.providerData) {
          if (provider.providerId == 'google.com') {
            // Sign out from Google if the user signed in with Google
            await _googleSignIn.signOut();
            await _googleSignIn.disconnect();
            break;
          }
        }

        // Sign out from Firebase
        await _auth.signOut();
      }

      // Set the logout flag to true in SharedPreferences (this avoids google sign in silently when loggingOut)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedOut', true);

      return true;
    } on Exception catch (e) {
      print("Error signing out: $e");
      return false;
    }
  }

  // Anonymous Login
  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print('Anonymous sign-in failed: $e');
      return null;
    }
  }

  // Método para obtener el usuario actual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //Logout
  Future<void> logout() async {
    await _auth.signOut();
    await _auth.authStateChanges().first;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedOut', true);
  }
}
