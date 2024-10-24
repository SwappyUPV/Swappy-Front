import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../home/components/user_header.dart';
import 'components/item_grid.dart';

class Exchanges extends StatelessWidget {
  const Exchanges({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        // Scroll general para todo el contenido
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // UserHeader para mí
            const UserHeader(
              nombreUsuario: "Nicolas Maduro",
              fotoUrl: "assets/images/bag_1.png",
              esMio: true,
            ),
            // Cuadrícula de mis items
            ItemGrid(items: products),
            // Línea de intercambio con ícono
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Expanded(child: Divider()),
                  Icon(Icons.swap_horiz, size: 32),
                  Expanded(child: Divider()),
                ],
              ),
            ),

            // UserHeader para otro usuario
            const UserHeader(
              nombreUsuario: "Putin",
              fotoUrl: "assets/images/bag_1.png",
              esMio: false,
            ),
          ],
        ),
      ),
    );
  }
}
