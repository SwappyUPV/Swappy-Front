import 'package:flutter/material.dart';
import '../../../../core/services/catalogue.dart';
import '../widgets/catalogue_app_bar.dart';
import '../widgets/search_bar.dart' as CustomWidgets;
import '../widgets/category_filter.dart';
import '../widgets/catalogue_grid.dart';

class Catalogue extends StatefulWidget {
  const Catalogue({Key? key}) : super(key: key);

  @override
  _CatalogueState createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {
  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  List<Map<String, dynamic>> catalogoRopa = [];
  Set<String> _categories = {'Todos'};
  bool _isLoading = true;

  final CatalogService _catalogService = CatalogService();

  @override
  void initState() {
    super.initState();
    _loadClothes();
  }

  Future<void> _loadClothes() async {
    setState(() {
      _isLoading = true;
    });

    List<Map<String, dynamic>> clothes = await _catalogService.getClothes();

    // Create a set to hold the categories
    Set<String> categories = {'Todos'};

    for (var item in clothes) {
      categories.add(item['categoria']);
    }

    // Check if the widget is still mounted before calling setState
    if (!mounted) return;

    setState(() {
      catalogoRopa = clothes;
      _categories = categories;
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get filteredCatalogo {
    return catalogoRopa.where((item) {
      final matchesCategory = _selectedCategory == 'Todos' ||
          item['categoria'] == _selectedCategory;
      final matchesSearch = item['nombre']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          item['etiquetas'].any(
              (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CatalogueAppBar(),
      body: Column(
        children: [
          CustomWidgets.SearchBar(
            onSearch: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            productos:
                catalogoRopa.map((item) => item['nombre'] as String).toList(),
          ),
          CategoryFilter(
            categories: _categories.toList(),
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : CatalogueGrid(filteredCatalogo: filteredCatalogo),
          ),
        ],
      ),
    );
  }
}
