import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pin/features/profile/presentation/widgets/post_grid.dart';
import 'package:pin/features/profile/presentation/widgets/profile_header.dart';
import 'package:pin/features/rewards/rewards.dart';
import 'settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pin/features/auth/data/models/user_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserModel? _userModel;
  bool _isLoading = true; // State variable for loading

  @override
  void initState() {
    super.initState();
    _loadUserModel();
  }

  Future<void> _loadUserModel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userModelJson = prefs.getString('userModel');

      if (userModelJson != null) {
        Map<String, dynamic> userModelMap = jsonDecode(userModelJson);
        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            _userModel = UserModel.fromJson(userModelMap);
            _isLoading =
                false; // Set loading to false after userModel is loaded
          });
        }
      } else {
        // Handle case where user model is not found
        if (mounted) {
          setState(() {
            _isLoading = false; // Still stop loading
          });
        }
      }
    } catch (error) {
      // Handle JSON decoding errors or other exceptions
      print('Error loading user model: $error');
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading in case of error
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = kIsWeb ? 35 : 26; // Tamaño para íconos en web o móvil
    double fontSize = kIsWeb ? 20 : 15; // Tamaño para texto en web o móvil
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Align title to the left
          children: const [
            Text(
              'Perfil',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/prize.svg',
                  height: iconSize, // Tamaño responsivo del icono SVG
                ),
                const SizedBox(width: 4),
                Text(
                  "Recompensas",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSize, // Tamaño responsivo del texto
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Rewards()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.setting_2, color: Colors.black),
            onPressed: () {
              // Navigate to the settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading // Use loading state for UI
          ? Center(child: CircularProgressIndicator())
          : _userModel == null
              ? Center(child: Text('No user data available'))
              : Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align children to the left
                  children: [
                    ProfileHeader(
                        userModel:
                            _userModel!), // Pass the userModel to the profile header
                    const Divider(),
                    const Expanded(
                        child: PostGrid()), // Use the post grid widget
                  ],
                ),
    );
  }
}
