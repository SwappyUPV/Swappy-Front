import 'package:flutter/material.dart';
import '../../details/details_screen.dart';
import 'item_card.dart';

class ItemGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final bool showButtons;
  final VoidCallback? onAddItem;
  final Function(Map<String, dynamic>) onDeleteItem;
  final Function(int)? onRemoveItem;
  final bool showAddButton;

  const ItemGrid({
    Key? key,
    required this.items,
    this.onRemoveItem,
    this.onAddItem,
    required this.onDeleteItem,
    required this.showButtons,
    this.showAddButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount =
        (width / 120).floor(); // Ajustar el número de columnas
    final itemSize = (width - (crossAxisCount + 1) * 16) /
        crossAxisCount; // Calcular tamaño del item

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length + (showAddButton ? 1 : 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 0,
          crossAxisSpacing: 16,
          childAspectRatio: 0.7, // Ajustar relación de aspecto si es necesario
        ),
        itemBuilder: (context, index) {
          if (showAddButton && index == items.length) {
            return GestureDetector(
              onTap: onAddItem,
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Añadir',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
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
                    builder: (context) => DetailsScreen(product: items[index]),
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
