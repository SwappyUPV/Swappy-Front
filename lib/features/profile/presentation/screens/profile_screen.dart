import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:pin/features/auth/data/models/user_model.dart';
import 'package:pin/features/profile/presentation/screens/settings_screen.dart';
import 'package:pin/features/profile/presentation/widgets/profile_info.dart';
import 'package:pin/features/profile/presentation/widgets/profile_stats.dart';
import 'package:pin/features/profile/presentation/widgets/wardrobe_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _userModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserModel();
  }

  Future<void> _loadUserModel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userModelJson = prefs.getString('userModel');

      if (userModelJson != null && mounted) {
        setState(() {
          _userModel = UserModel.fromJson(jsonDecode(userModelJson));
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'MI PERFIL',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'UrbaneMedium',
            letterSpacing: -0.32,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () async {
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(userModel: _userModel!),
                ),
              );
              if (result == true) {
                _loadUserModel(); // Refresh user data
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userModel == null
          ? const Center(child: Text('No user data available'))
          : Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileStats(userModel: _userModel!),
                    ProfileInfo(userModel: _userModel!),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              WardrobeSection(userModel: _userModel!),
            ],
          ),
        ),
      ),
    );
  }
}