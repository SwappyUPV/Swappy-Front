import 'package:flutter/material.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';
import 'package:pin/features/wishlist/services/wishlist_service.dart';

class CatalogueItemCard extends StatefulWidget {
  final Product product;
  final VoidCallback press;

  const CatalogueItemCard({
    super.key,
    required this.product,
    required this.press,
  });

  @override
  State<CatalogueItemCard> createState() => _CatalogueItemCardState();
}

class _CatalogueItemCardState extends State<CatalogueItemCard> {
  final WishlistService _wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
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
                ],
              ),
            ),
            // 2. Foto del producto centrada
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  widget.product.image, // Imagen del producto
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            // 3. Nombre del producto (datos de ejemplo)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.product.title.isNotEmpty
                    ? widget.product.title
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
            // 4. Talla del producto (si no existe, poner M/38)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                widget.product.size.isEmpty
                    ? 'M/38'
                    : widget.product.size, // Talla o M/38 si no hay talla
                style: TextStyle(
                  fontFamily: 'UrbaneMedium', // Usando la fuente registrada
                  fontSize: 14, // Tamaño del texto
                ),
              ),
            ),
            // 5. Row con la palabra "Intercambio" y botón "+"
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
                    icon: Icon(
                      _wishlistService.isInWishlist(widget.product)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _wishlistService.isInWishlist(widget.product)
                          ? Colors.red
                          : null,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_wishlistService.isInWishlist(widget.product)) {
                          _wishlistService.removeFromWishlist(widget.product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Eliminado de la lista de deseados'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else {
                          _wishlistService.addToWishlist(widget.product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Añadido a la lista de deseados'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            // 6. Botón swap
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Exchanges(
                        selectedProduct: widget.product,
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
