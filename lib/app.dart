import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX package
import 'package:pin/core/utils/NavigationMenu/NavigationMenu.dart';
import 'package:pin/core/constants/constants.dart';

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
      home: NavigationMenu(), // This can remain as it is
    );
  }
}