// settings_screen.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pin/core/services/authentication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
          _buildSettingsItem(Iconsax.user_edit, 'Nombre', () {}),
          _buildSettingsItem(Iconsax.size, 'Tallas', () {}),
          _buildSettingsItem(Iconsax.calendar, 'Fecha Nacimiento', () {}),
          _buildSettingsItem(Iconsax.map, 'Localidad', () {}),
          _buildSettingsItem(Iconsax.lock, 'Contraseña', () {}),
          _buildSettingsItem(Iconsax.message, 'Correo', () {}),
          _buildSettingsItem(Iconsax.logout, 'Cerrar sesión', () async {
            await AuthMethod().logout();
            final NavigationController navigationController = Get.find<NavigationController>();
            navigationController.updateIndex(0);
            Get.offAll(() => NavigationMenu());
          }),
          _buildSettingsItem(Iconsax.profile_delete, 'Eliminar cuenta y datos', () async {
            await AuthMethod().deleteUser();
            final NavigationController navigationController = Get.find<NavigationController>();
            navigationController.updateIndex(0);
            Get.offAll(() => NavigationMenu());
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
