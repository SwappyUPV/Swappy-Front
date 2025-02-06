import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX package
import 'package:pin/core/utils/NavigationMenu/NavigationMenu.dart';
import 'package:pin/core/constants/constants.dart';
import 'package:pin/features/add_product/presentation/screens/upload_product_screen.dart';
import 'package:pin/features/auth/presentation/screens/login_screen.dart';
import 'package:pin/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:pin/features/catalogue/presentation/screens/catalogue_screen.dart';
import 'package:pin/features/chat/presentation/screens/chats/chats_screen.dart';
import 'package:pin/features/profile/presentation/screens/profile_screen.dart';
import 'package:pin/features/virtual_closet/presentation/screens/virtual_closet_screen.dart';

class Swappy extends StatelessWidget {
  const Swappy({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swappy',
      theme: ThemeData(
        primaryColor: PrimaryColor, // This is the primary color of the app,
        scaffoldBackgroundColor: Colors.white,
        dialogBackgroundColor: Colors.white, // Set dialog background color to white
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            foregroundColor: Colors.white,
            backgroundColor: PrimaryColor,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 56),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: SecondaryColor,
          iconColor: PrimaryColor,
          prefixIconColor: PrimaryColor,
          contentPadding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'UrbaneMedium'),
          bodyMedium: TextStyle(fontFamily: 'UrbaneLight'),
          headlineLarge: TextStyle(fontFamily: 'UrbaneBold'),
          headlineMedium: TextStyle(fontFamily: 'UrbaneBold'),
          headlineSmall: TextStyle(fontFamily: 'UrbaneBold'),
          titleLarge: TextStyle(fontFamily: 'UrbaneMedium'),
          titleMedium: TextStyle(fontFamily: 'UrbaneMedium'),
          titleSmall: TextStyle(fontFamily: 'UrbaneMedium'),
          labelLarge: TextStyle(fontFamily: 'UrbaneLight'),
          labelMedium: TextStyle(fontFamily: 'UrbaneLight'),
          labelSmall: TextStyle(fontFamily: 'UrbaneLight'),
          displayLarge: TextStyle(fontFamily: 'UrbaneBold'),
          displayMedium: TextStyle(fontFamily: 'UrbaneBold'),
          displaySmall: TextStyle(fontFamily: 'UrbaneBold'),
        ),
      ),
      initialRoute: '/', // Set initial route
      routes: {
        '/': (context) => NavigationMenu(),
        '/NavigationMenu': (context) => NavigationMenu(),
        '/SignUpScreen': (context) => SignUpScreen(),
        '/LoginScreen': (context) => Login(),
        '/ProfileScreen': (context) => ProfileScreen(), // Define ProfileScreen route
        '/VirtualClosetScreen': (context) => VirtualClosetScreen(), // Define VirtualClosetScreen route
        '/CatalogueScreen': (context) => CatalogueScreen(), // Define CatalogueScreen route
        '/UploadProductScreen': (context) => UploadProductScreen(), // Define UploadProductScreen route
        '/ChatsScreen': (context) => ChatsScreen(), // Define ChatsScreen route
      },// This can remain as it is
    );
  }
}