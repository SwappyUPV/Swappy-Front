import 'package:flutter/material.dart';

import '../../../constants.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.product,
    required this.press,
    required this.onDelete,
    this.showDeleteButton = false,
  });

  final Map<String, dynamic> product;
  final VoidCallback press;
  final VoidCallback onDelete;
  final bool showDeleteButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press, // Navegar a la pantalla de detalles
      child: Stack(
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centra el contenido
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(kDefaultPaddin),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Hero(
                    tag: "${product['id']}",
                    child: Center(
                      child: Image.asset(
                        product['image'] as String,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
                child: Text(
                  product['title'] as String,
                  textAlign: TextAlign.center, // Centra el texto
                  style: const TextStyle(
                    color: Color.fromARGB(255, 53, 53, 53),
                  ),
                ),
              ),
            ],
          ),
          if (showDeleteButton)
            Positioned(
              right: 6,
              top: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                width: 24,
                height: 24,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.black, size: 15),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
