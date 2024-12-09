import 'package:flutter/material.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';

class CatalogueItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback press;
  final bool isFavorite; // Parámetro para saber si el producto es favorito
  final Function toggleFavorite; // Función para cambiar el estado de favorito

  const CatalogueItemCard({
    super.key,
    required this.product,
    required this.press,
    required this.isFavorite, // Recibimos el estado de favorito
    required this.toggleFavorite, // Recibimos la función para cambiar el estado de favorito
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // Bordes más redondeados
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Foto de perfil y nombre de usuario (datos de ejemplo)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/images/user_2.png'), // Imagen de ejemplo del perfil
                    radius: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pepe', // Nombre de usuario de ejemplo
                      style: TextStyle(
                        fontFamily:
                            'UrbaneMedium', // Usando la fuente registrada
                        fontSize: 18, // Tamaño del texto
                      ),
                    ),
                  ),
                  // 2. Ícono de favorito
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () =>
                        toggleFavorite(), // Llamar a la función para cambiar el estado de favorito
                  ),
                ],
              ),
            ),
            // 3. Foto del producto centrada
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  product.image, // Imagen del producto
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            // 4. Nombre del producto (datos de ejemplo)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                product.title.isNotEmpty
                    ? product.title
                    : 'Camiseta de Verano', // Nombre del producto o ejemplo
                style: TextStyle(
                  fontFamily: 'UrbaneMedium', // Usando la fuente registrada
                  fontSize: 16, // Tamaño del texto
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // 5. Talla del producto (si no existe, poner M/38)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                product.size.isEmpty
                    ? 'M/38'
                    : product.size, // Talla o M/38 si no hay talla
                style: TextStyle(
                  fontFamily: 'UrbaneMedium', // Usando la fuente registrada
                  fontSize: 14, // Tamaño del texto
                ),
              ),
            ),
            // 6. Row con la palabra "Intercambio" y botón "+"
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Intercambio',
                    style: TextStyle(
                      fontFamily: 'UrbaneMedium', // Usando la fuente registrada
                      fontSize: 14, // Tamaño del texto
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      // Acción para el botón "+"
                    },
                  ),
                ],
              ),
            ),
            // 7. Botón swap
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Exchanges(
                        selectedProduct: product,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 36),
                ),
                child: Text(
                  'SWAP',
                  style: TextStyle(
                    fontFamily: 'UrbaneMedium', // Usando la fuente registrada
                    fontSize: 16, // Tamaño del texto
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
