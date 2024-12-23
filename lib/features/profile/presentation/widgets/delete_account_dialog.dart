import 'package:flutter/material.dart';
import 'package:pin/core/services/authentication_service.dart';
import 'package:get/get.dart';
import 'package:pin/core/utils/NavigationMenu/NavigationMenu.dart';
import 'package:pin/core/utils/NavigationMenu/controllers/navigationController.dart';

Future<void> showDeleteAccountDialog(BuildContext context, AuthMethod authService) async {
  TextEditingController controller = TextEditingController();
  bool? confirm = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          bool _isSaving = false;

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Borrar cuenta',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Ingrese motivo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  setState(() {
                    _isSaving = true;
                  });
                  await Future.delayed(const Duration(seconds: 1)); // Simulate saving process
                  setState(() {
                    _isSaving = false;
                  });
                  Navigator.of(context).pop(true);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.red, size: 60),
                            const SizedBox(height: 16),
                            const Text('Cuenta borrada', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ), label:const Text(''),
              ),
            ],
          );
        },
      );
    },
  );

  if (confirm == true) {
    await authService.deleteUser();
    await authService.signOut();
    final NavigationController navigationController = Get.find<NavigationController>();
    navigationController.updateIndex(0);
    Get.offAll(() => NavigationMenu());
  }
}