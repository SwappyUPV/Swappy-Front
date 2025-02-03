import 'package:flutter/material.dart';
import 'package:pin/features/catalogue/presentation/screens/favorites.dart';
import 'package:pin/features/catalogue/presentation/widgets/header.dart';
import '../../../../core/services/catalogue.dart';
import '../widgets/search_bar.dart' as CustomWidgets;
import '../widgets/category_filter.dart';
import '../widgets/catalogue_grid.dart';
import 'package:pin/features/exchanges/models/Product.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  _CatalogueScreenState createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
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
  Set<Product> favoriteProducts = {}; // Set para favoritos

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

    if (!mounted) return;

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

  void _toggleFavorite(Product product) {
    setState(() {
      if (favoriteProducts.contains(product)) {
        favoriteProducts.remove(product);
      } else {
        favoriteProducts.add(product);
      }
    });
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
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Stack(
                      children: [
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, right: 8.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                              iconSize: 30.0,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FavoritesScreen(
                                      favoriteProducts:
                                          favoriteProducts.toList(),
                                    ),
                                  ),
                                );
                              },
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
                  Padding(
                    padding: const EdgeInsets.only(top: 100, left: 40),
                    child: Column(
                      children: [
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
                subtitle: 'Los estilos que están arrasando',
                imageAsset: 'assets/icons/Linea5.svg',
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
                : CatalogueGrid(
                    filteredCatalogo: filteredCatalogo,
                    toggleFavorite: _toggleFavorite,
                    favoriteProducts: favoriteProducts,
                  ),
          ],
        ),
      ),
    );
  }
}
