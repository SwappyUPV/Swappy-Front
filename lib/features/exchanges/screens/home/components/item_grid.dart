import 'package:flutter/material.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/virtual_closet/presentation/screens/change_clothes_screen.dart';
import 'package:pin/features/virtual_closet/presentation/screens/virtual_closet_screen.dart';
import '../../details/details_screen.dart'; // Importa el VirtualCloset
import 'item_card.dart';

class ItemGrid extends StatelessWidget {
  final List<Product> items;
  final bool showButtons;
  final Function(Product) onDeleteItem;
  final void Function(List<Product>)? onAddItem;
  final String? id;
  const ItemGrid({
    super.key,
    required this.items,
    required this.showButtons,
    required this.onAddItem,
    required this.onDeleteItem,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount =
        width > 600 ? 6 : 3; // Más columnas en pantallas grandes
    final itemSize = (width - (crossAxisCount + 1) * 16) /
        crossAxisCount; // Calcular tamaño del item

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length + (showButtons && onAddItem != null ? 1 : 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 0,
          crossAxisSpacing: 16,
          childAspectRatio: 0.7, // Ajustar relación de aspecto si es necesario
        ),
        itemBuilder: (context, index) {
          if (index == items.length && showButtons && onAddItem != null) {
            return GestureDetector(
              onTap: () async {
                if (onAddItem != null && id != null) {
                  // Navegar al VirtualCloset y esperar selección
                  final List<Product>? selectedProducts = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangeClothes(fromExchange: true , id : id),
                    ),
                  );
                  if (selectedProducts != null) {
                    onAddItem!(selectedProducts);
                  }
                }
                else if (onAddItem != null) {
                  // Navegar al VirtualCloset y esperar selección
                  final List<Product>? selectedProducts = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const ChangeClothes(fromExchange: true),
                    ),
                  );
                  if (selectedProducts != null) {
                    onAddItem!(selectedProducts);
                  }
                }

              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(
                          16.0), // Puedes usar kDefaultPaddin
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Icon(Icons.add, size: 40, color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Añadir",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ItemCard(
              product: items[index],
              press: () {
                // Navegar a la pantalla de detalles
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      product: items[index],
                      showActionButtons: false,
                    ),
                  ),
                );
              },
              showDeleteButton: showButtons,
              onDelete: () => onDeleteItem(items[index]),
            );
          }
        },
      ),
    );
  }
}
