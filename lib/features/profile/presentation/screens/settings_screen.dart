import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pin/core/services/authentication_service.dart';
import 'package:get/get.dart';
import 'package:pin/core/utils/NavigationMenu/NavigationMenu.dart';
import 'package:pin/core/utils/NavigationMenu/controllers/navigationController.dart';
import 'package:pin/features/auth/data/models/user_model.dart';
import 'package:pin/features/profile/presentation/services/user_update_service.dart';
import 'package:pin/features/profile/presentation/widgets/delete_account_dialog.dart';
import 'package:pin/features/profile/presentation/widgets/edit_birthday_dialog.dart';
import 'package:pin/features/profile/presentation/widgets/edit_dialog.dart';
import 'package:pin/features/profile/presentation/widgets/settings_item.dart';

class SettingsScreen extends StatefulWidget {
  final UserModel userModel;

  const SettingsScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late UserModel _userModel;
  final _authService = AuthMethod();
  late UserUpdateService _userUpdateService;

  @override
  void initState() {
    super.initState();
    _userModel = widget.userModel;
    _userUpdateService = UserUpdateService(_userModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Ajustes',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsItem(
            icon: Iconsax.user_edit,
            title: 'Nombre',
            onTap: () async {
              String? newName = await showEditDialog(context, 'Nombre', _userModel.name);
              if (newName != null) {
                await _userUpdateService.updateUserField('name', newName);
              }
            },
          ),
          SettingsItem(
            icon: Iconsax.size,
            title: 'Tallas',
            onTap: () async {
              String? newSize = await showEditDialog(
                context,
                'Tallas',
                _userModel.preferredSizes != null && _userModel.preferredSizes!.isNotEmpty
                    ? _userModel.preferredSizes!.join(', ')
                    : '',
              );
              if (newSize != null) {
                await _userUpdateService.updateUserField('size', newSize);
              }
            },
          ),
          SettingsItem(
            icon: Iconsax.calendar,
            title: 'Fecha Nacimiento',
            onTap: () async {
              await EditBirthdayDialog(context, _userUpdateService).showEditBirthdayDialog();
            },
          ),
          SettingsItem(
            icon: Iconsax.map,
            title: 'Localidad',
            onTap: () async {
              String? newLocation = await showEditDialog(context, 'Localidad', _userModel.address ?? '');
              if (newLocation != null) {
                await _userUpdateService.updateUserField('location', newLocation);
              }
            },
          ),
          SettingsItem(
            icon: Iconsax.lock,
            title: 'Contraseña',
            onTap: () async {
              String? newPassword = await showEditDialog(context, 'Contraseña', '');
              if (newPassword != null) {
                await _authService.updatePassword(newPassword);
              }
            },
          ),
          SettingsItem(
            icon: Iconsax.logout,
            title: 'Cerrar sesión',
            onTap: () async {
              await _authService.logout();
              final NavigationController navigationController = Get.find<NavigationController>();
              navigationController.updateIndex(0);
              Get.offAll(() => NavigationMenu());
            },
          ),
          SettingsItem(
            icon: Iconsax.profile_delete,
            title: 'Eliminar cuenta y datos',
            onTap: () async {
              await showDeleteAccountDialog(context, _authService);
            },
          ),
        ],
      ),
    );
  }
}