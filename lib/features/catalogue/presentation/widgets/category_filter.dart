import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryFilter({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 16),
          for (String category in categories)
            GestureDetector(
              onTap: () {
                print(
                    'assets/images/$category.png'); // Imprime la ruta de la imagen
                onCategorySelected(
                    category); // Llama al callback para seleccionar la categoría
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
                            'assets/images/$category.png', // Cambia según tus imágenes
                          ),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: selectedCategory == category
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 23,
                            fontFamily: 'UrbaneMid',
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
