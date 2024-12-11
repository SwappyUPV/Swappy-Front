import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({Key? key}) : super(key: key);

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final List<String> categories = ['Ropa', 'Calzado', 'Accesorios'];
  final List<String> styles = ['Casual', 'Formal', 'Deportivo'];
  final List<String> sizes = ['XS', 'S', 'M', 'L', 'XL'];

  String? selectedCategory;
  String? selectedStyle;
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCustomExpansionTile(
          'Categoría',
          categories,
          selectedCategory,
              (value) => setState(() => selectedCategory = value),
        ),
        _buildCustomExpansionTile(
          'Estilo',
          styles,
          selectedStyle,
              (value) => setState(() => selectedStyle = value),
        ),
        _buildCustomExpansionTile(
          'Tallas',
          sizes,
          selectedSize,
              (value) => setState(() => selectedSize = value),
        ),
      ],
    );
  }

  Widget _buildCustomExpansionTile(
      String title,
      List<String> items,
      String? selectedValue,
      ValueChanged<String?> onChanged,
      ) {
    bool isExpanded = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.only(left: 30, right: 30),
              title: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'UrbaneMedium',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.28,
                    ),
                  ),
                  if (selectedValue != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        selectedValue,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              trailing: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                color: Colors.black,
              ),
              onExpansionChanged: (expanded) {
                setState(() => isExpanded = expanded);
              },
              children: [
                Container(
                  color: Colors.white, // Background for dropdown items
                  child: Column(
                    children: items.map((item) {
                      final isSelected = selectedValue == item;
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.only(left: 40, right: 35),
                            title: Text(
                              item,
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check, color: Colors.black)
                                : null,
                            onTap: () {
                              onChanged(isSelected ? null : item);
                            },
                          ),
                          if (item != items.last)
                            Divider(
                              color: Colors.grey.shade300,
                              height: 1,
                              indent: 30,
                              endIndent: 30,
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}