import 'package:flutter/material.dart';
import '/core/services/product.dart';

class CategorySelector extends StatefulWidget {
  final List<String> categories;
  final List<String> styles;
  final List<String> sizes;
  final List<String> qualities; // Add this line
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onStyleSelected;
  final ValueChanged<String> onSizeSelected;
  final ValueChanged<String> onQualitySelected; // Add this line

  const CategorySelector({
    Key? key,
    required this.categories,
    required this.styles,
    required this.sizes,
    required this.qualities, // Add this line
    required this.onCategorySelected,
    required this.onStyleSelected,
    required this.onSizeSelected,
    required this.onQualitySelected, // Add this line
  }) : super(key: key);

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String? selectedCategory;
  String? selectedStyle;
  String? selectedSize;
  String? selectedQuality;
  List<String> availableSizes = [];
  final Map<String, ExpansionTileController> _controllers = {
    'Categoría': ExpansionTileController(),
    'Estilo': ExpansionTileController(),
    'Talla': ExpansionTileController(),
    'Calidad': ExpansionTileController(),
  };

  final ProductService _productService = ProductService();

  void _updateSizesForCategory(String category) async {
    final sizes = await _productService.getSizes(category);
    setState(() {
      availableSizes = sizes;
      selectedSize = null; // Reset selected size when category changes
    });
  }

  void _collapseOtherMenus(String currentMenu) {
    _controllers.forEach((menu, controller) {
      if (menu != currentMenu) {
        controller.collapse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCustomExpansionTile(
          'Categoría',
          widget.categories,
          selectedCategory,
          (value) {
            setState(() => selectedCategory = value);
            if (value != null) {
              _updateSizesForCategory(value);
            }
            widget.onCategorySelected(value!);
            _controllers['Categoría']?.collapse();
          },
        ),
        _buildCustomExpansionTile(
          'Estilo',
          widget.styles,
          selectedStyle,
          (value) {
            setState(() => selectedStyle = value);
            widget.onStyleSelected(value!);
            _controllers['Estilo']?.collapse();
          },
        ),
        _buildCustomExpansionTile(
          'Talla',
          availableSizes,
          selectedSize,
          (value) {
            setState(() => selectedSize = value);
            widget.onSizeSelected(value!);
            _controllers['Talla']?.collapse();
          },
        ),
        _buildCustomExpansionTile(
          'Calidad',
          widget.qualities,
          selectedQuality,
          (value) {
            setState(() => selectedQuality = value);
            widget.onQualitySelected(value!);
            _controllers['Calidad']?.collapse();
          },
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
              controller: _controllers[title],
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                if (expanded) {
                  _collapseOtherMenus(title);
                }
              },
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: items.map((item) {
                      final isSelected = selectedValue == item;
                      return Column(
                        children: [
                          ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 40, right: 35),
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
