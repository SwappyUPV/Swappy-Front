import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class CategoryFilter extends StatefulWidget {
  final List<String?> categories;
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  // Lista fija de imágenes y nombres para los primeros 5 estilos
  static const List<Map<String, String>> styleImages = [
    {'name': 'Clásico', 'image': 'Streetwear'},
    {'name': 'Elegante', 'image': 'Grunge'},
    {'name': 'Hippie', 'image': 'Motorsport'},
    {'name': 'Casual', 'image': 'Y2K'},
    {'name': 'Vintage', 'image': 'Coquette'}
  ];

  // Mapeo de categorías a imágenes
  static const Map<String, String> categoryImages = {
    'Accesorios': 'Accesorios',
    'Camisetas': 'Camisetas',
    'Pantalones': 'Pantalones',
    'Zapatos': 'Zapatos'
  };

  const CategoryFilter({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  State<CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  final ScrollController scrollController = ScrollController();
  bool isDragging = false;
  double startX = 0;
  double scrollStartPosition = 0;

  List<String> _getAllItems() {
    // Primero los estilos
    List<String> items =
        CategoryFilter.styleImages.map((style) => style['name']!).toList();
    // Luego las categorías
    items.addAll(CategoryFilter.categoryImages.keys);
    return items;
  }

  String _getImageForItem(String item, int index) {
    if (index < CategoryFilter.styleImages.length) {
      // Si es un estilo, obtener la imagen correspondiente
      return CategoryFilter.styleImages[index]['image']!;
    }
    // Si es una categoría, obtener la imagen de la categoría
    return CategoryFilter.categoryImages[item] ?? item;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> allItems = _getAllItems();

    return GestureDetector(
      onHorizontalDragStart: (details) {
        isDragging = true;
        startX = details.globalPosition.dx;
        scrollStartPosition = scrollController.offset;
      },
      onHorizontalDragUpdate: (details) {
        if (isDragging) {
          final double difference = startX - details.globalPosition.dx;
          scrollController.jumpTo(scrollStartPosition + difference);
        }
      },
      onHorizontalDragEnd: (_) {
        isDragging = false;
      },
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 16),
            for (int i = 0; i < allItems.length; i++)
              GestureDetector(
                onTap: () {
                  widget.onCategorySelected(allItems[i]);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/${_getImageForItem(allItems[i], i)}.png',
                            ),
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                          border: Border.all(
                            color: widget.selectedCategory == allItems[i]
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : Colors.grey,
                            width: 1,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          allItems[i],
                          style: TextStyle(
                            fontSize: 23,
                            fontFamily: 'UrbaneMid',
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
