import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin/features/catalogue/presentation/widgets/header.dart';
import '../../../../core/services/catalogue.dart';
import '../widgets/catalogue_app_bar.dart';
import '../widgets/search_bar.dart' as CustomWidgets;
import '../widgets/category_filter.dart';
import '../widgets/catalogue_grid.dart';
import 'package:pin/features/exchanges/models/Product.dart';

class Catalogue extends StatefulWidget {
  const Catalogue({super.key});

  @override
  _CatalogueState createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {
  String _selectedCategory = 'Streetwear';
  String _searchQuery = '';
  List<Product> catalogoRopa = [];
  Set<String> _categories = {
    'Streetwear',
    'Grunge',
    'Motorsport',
    'Y2K',
    'Coquette',
    'Glam'
  };
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
    List<Product> clothes = await _catalogService.getClothes();
    Set<String> categories = {
      'Streetwear',
      'Grunge',
      'Motorsport',
      'Y2K',
      'Coquette',
      'Glam'
    };

    for (var item in clothes) {
      categories.add(item.category);
    }

    if (!mounted) return; // Check to avoid setState after widget is disposed

    setState(() {
      catalogoRopa = clothes;
      _categories = categories;
      _isLoading = false;
    });
  }

  List<Product> get filteredCatalogo {
    return catalogoRopa.where((item) {
      final matchesCategory = _selectedCategory == 'Streetwear' ||
          item.category == _selectedCategory;
      final matchesSearch = item.title
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          item.styles.any(
              (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider de nueva temporada
            Container(
              height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/portadas/portada1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row con logo y botón
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Stack(
                      children: [
                        // Logo centrado horizontalmente
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 13.0),
                            child: Image.asset(
                              'assets/icons/logo.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        // Iconos alineados a la derecha
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, right: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                  iconSize: 30.0,
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Pantalla de favoritos no implementada'),
                                      ),
                                    );
                                  },
                                ),
                                Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomWidgets.SearchBar(
                    onSearch: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    productos: catalogoRopa.map((item) => item.title).toList(),
                  ),
                  // Contenido principal del slider
                  Padding(
                    padding: const EdgeInsets.only(top: 100, left: 40),
                    child: Column(
                      children: [
                        // "RENUEVA" alineado a la izquierda
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'RENUEVA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // "TEMPORADA" e "INVIERNO 2024" centrados
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'TEMPORADA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'INVIERNO 2024',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            Column(children: [
              Header(
                title: 'On Trend',
                subtitle: 'The styles that are taking over',
                imageAsset: 'assets/icons/Linea5.svg', // Este es opcional
              ),
            ]),
            SizedBox(height: 20),

            CategoryFilter(
              categories: _categories.toList(),
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            SizedBox(height: 25),
            Header(
                title: 'Newsfeed',
                subtitle: 'Descubre lo que ofrecen otros usuarios'),
            _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : CatalogueGrid(filteredCatalogo: filteredCatalogo),
          ],
        ),
      ),
    );
  }
}
