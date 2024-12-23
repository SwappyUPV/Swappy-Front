import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pin/features/auth/data/models/user_model.dart';
import 'package:pin/features/profile/presentation/services/user_update_service.dart';

class EditBirthdayDialog {
  final BuildContext context;
  final UserUpdateService userUpdateService;

  EditBirthdayDialog(this.context, this.userUpdateService);

  Future<void> showEditBirthdayDialog() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: userUpdateService.userModel.birthday?.toDate() ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      await userUpdateService.updateUserField('birthday', Timestamp.fromDate(selectedDate));
    }
  }
}