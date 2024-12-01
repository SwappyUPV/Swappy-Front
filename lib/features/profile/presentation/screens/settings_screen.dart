// settings_screen.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pin/core/services/authentication_service.dart';
import '../../../../core/utils/NavigationMenu/NavigationMenu.dart';
import 'package:get/get.dart';
import 'package:pin/core/utils/NavigationMenu/controllers/navigationController.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to profile screen
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsItem(Iconsax.user_edit, 'Change Name', () {}),
          _buildSettingsItem(Iconsax.size, 'Change Preferred Sizes', () {}),
          _buildSettingsItem(Iconsax.calendar, 'Change Birthday', () {}),
          _buildSettingsItem(Iconsax.map, 'Change Address', () {}),
          _buildSettingsItem(Iconsax.lock, 'Change Password', () {}),
          _buildSettingsItem(Iconsax.message, 'Change Email', () {}),
          _buildSettingsItem(Iconsax.logout, 'Logout', () async {
            await AuthMethod().logout();
            Navigator.of(context).pop();
            final NavigationController navigationController =
                Get.find<NavigationController>();
            navigationController.updateIndex(4);
            Get.off(() => NavigationMenu());
          }),
          _buildSettingsItem(Iconsax.profile_delete, 'Delete account', () {}),
        ],
      ),
    );
  }

  // Each settings item in the list
  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
