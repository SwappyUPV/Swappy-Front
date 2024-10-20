import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:window_manager/window_manager.dart';
import 'core/constants/firebase_options.dart';
import 'app.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import './features/chat/state/chat_provider.dart';

void main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Create a new instance of [StreamChatClient] passing the apikey obtained from your
  /// project dashboard.
  final client = StreamChatClient(
    'b67pax5b2wdq',
    logLevel: Level.INFO,
  );

  /// Set the current user. In a production scenario, this should be done using
  /// a backend to generate a user token using our server SDK.
  /// Please see the following for more information:
  /// https://getstream.io/chat/docs/flutter-dart/tokens_and_authentication/?language=dart
  await client.connectUser(
    User(id: 'tutorial-flutter'),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHV0b3JpYWwtZmx1dHRlciJ9.S-MJpoSwDiqyXpUURgO5wVqJ4vKlIVFLSEyrFYCOE1c',
  );

  /// Creates a channel using the type `messaging` and `flutterdevs`.
  /// Channels are containers for holding messages between different members. To
  /// learn more about channels and some of our predefined types, checkout our
  /// our channel docs: https://getstream.io/chat/docs/flutter-dart/creating_channels/?language=dart
  final channel = client.channel('messaging', id: 'flutterdevs');

  /// `.watch()` is used to create and listen to the channel for updates. If the
  /// channel already exists, it will simply listen for new events.
  await channel.watch();

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
  runApp(
    StreamChatProvider(
      client: client,
      channel: channel,
      child: const MyApp(),
    ),
  );
}
