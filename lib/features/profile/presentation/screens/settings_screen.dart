// settings_screen.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pin/core/services/authentication_service.dart';
import '/features/catalogue/presentation/widgets/navigation_menu.dart';
import 'package:get/get.dart';

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
          _buildSettingsItem(Iconsax.user_edit, 'Change Username', () {}),
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
