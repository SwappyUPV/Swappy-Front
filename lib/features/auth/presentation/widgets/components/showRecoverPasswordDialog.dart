import 'package:flutter/material.dart';
import 'package:pin/core/services/authentication_service.dart';

Future<void> showRecoverPasswordDialog(BuildContext context) async {
  TextEditingController emailController = TextEditingController();
  final _authService = AuthMethod();

  return showDialog<void>(
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
                  'Recuperar contraseña',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Ingrese correo electrónico',
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
            actions: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isSaving = true;
                  });
                  await _authService.sendPasswordResetEmail(emailController.text);
                  setState(() {
                    _isSaving = false;
                  });
                  Navigator.of(context).pop();
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
                            const Icon(Icons.check_circle, color: Colors.green, size: 60),
                            const SizedBox(height: 16),
                            const Center(
                              child: Text(
                                'Enviado',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Enviar',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'UrbaneMedium',
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}