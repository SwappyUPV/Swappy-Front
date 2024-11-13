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
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: 16),
          for (String categoria in categories)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(categoria),
                selected: selectedCategory == categoria,
                onSelected: (selected) {
                  if (selected) {
                    onCategorySelected(categoria);
                  }
                },
                selectedColor: Colors.teal.shade100,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
