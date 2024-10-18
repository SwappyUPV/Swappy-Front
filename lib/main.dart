import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:window_manager/window_manager.dart';
import 'core/constants/firebase_options.dart';
import 'app.dart';

void main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set minimum window size only for desktop (can't set it for web, browsers don't allow it)
  /*
  if (!kIsWeb) { ADD ALSO NOT FOR ANDROID AND IOS
    await windowManager.ensureInitialized(); // Ensure the window manager is initialized
    const double minWidth = 400; // Minimum width
    const double minHeight = 800; // Minimum height

    // Use window_manager to set the minimum window size
    await windowManager.setMinimumSize(Size(minWidth, minHeight));
  }
  */
  // Run the app
  runApp(const MyApp());
}