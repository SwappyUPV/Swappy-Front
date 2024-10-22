import 'package:flutter/material.dart';

class VirtualCloset extends StatelessWidget {
  const VirtualCloset({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Armario Virtual'),
      ),
      body: const Center(
        child: Text('Contenido del armario virtual'),
      ),
    );
  }
}
