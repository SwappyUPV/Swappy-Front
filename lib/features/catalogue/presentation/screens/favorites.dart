import 'package:flutter/material.dart';
import 'package:pin/features/catalogue/presentation/widgets/catalogue_item_card.dart';
import 'package:pin/features/catalogue/presentation/widgets/favorites_app_bar.dart';
import 'package:pin/features/exchanges/models/Product.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Product> favoriteProducts;

  const FavoritesScreen({
    super.key,
    required this.favoriteProducts,
  });

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Product> _favoriteProducts;

  @override
  void initState() {
    super.initState();
    _favoriteProducts = List.from(widget.favoriteProducts);
  }

  // Función para alternar el estado de favorito
  void toggleFavorite(Product product) {
    setState(() {
      if (_favoriteProducts.contains(product)) {
        _favoriteProducts.remove(product); // Eliminar si ya está en favoritos
      } else {
        _favoriteProducts.add(product); // Agregar si no está en favoritos
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FavoritesAppBar(),
      body: _favoriteProducts.isEmpty
          ? const Center(child: Text('No tienes productos favoritos aún.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: _favoriteProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.5,
                ),
                itemBuilder: (context, index) {
                  final product = _favoriteProducts[index];
                  return CatalogueItemCard(
                    product: product,
                    press: () {
                      // Acción al presionar un favorito, por ejemplo, navegar a detalles
                    },
                    isFavorite: true, // Siempre es favorito en esta pantalla
                    toggleFavorite: () =>
                        toggleFavorite(product), // Cambiar estado de favorito
                  );
                },
              ),
            ),
    );
  }
}
