import 'package:flutter/material.dart';
import 'package:pin/features/catalogue/presentation/screens/easter_egg.dart';
import 'package:pin/features/catalogue/presentation/screens/favorites.dart';
import 'package:pin/features/catalogue/presentation/widgets/header.dart';
import '../../../../core/services/catalogue.dart';
import '../widgets/search_bar.dart' as CustomWidgets;
import '../widgets/category_filter.dart';
import '../widgets/catalogue_grid.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/features/rewards/rewards.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  _CatalogueScreenState createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  String? _selectedCategory;
  String? _selectedStyle;
  String _searchQuery = '';
  List<Product> catalogoRopa = [];
  Set<String> _categories = {};
  Set<String> _styles = {};
  bool _isLoading = true;
  Set<Product> favoriteProducts = {};
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  final CatalogService _catalogService = CatalogService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final categories = await _catalogService.getCategories();
      final styles = await _catalogService.getStyles();
      final clothes = await _catalogService.getClothes();

      if (!mounted) return;

      setState(() {
        _categories = categories;
        _styles = styles;
        // Filtrar los productos para excluir los del usuario actual
        catalogoRopa = clothes
            .where((product) => product.userId != currentUserId)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Product> get filteredCatalogo {
    return catalogoRopa.where((item) {
      // Excluir productos del usuario actual
      if (item.userId == currentUserId) {
        return false;
      }

      bool matchesFilter = true;

      if (_selectedStyle != null && _selectedStyle!.isNotEmpty) {
        // Primero verificar si es una categoría
        if (CategoryFilter.categoryImages.containsKey(_selectedStyle)) {
          matchesFilter = item.category == _selectedStyle;
        } else {
          // Si no es una categoría, es un estilo
          matchesFilter = item.styles.contains(_selectedStyle);
        }
      }

      final matchesSearch =
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.styles.any((style) =>
                  style.toLowerCase().contains(_searchQuery.toLowerCase()));

      return matchesFilter && matchesSearch;
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.store, color: Colors.white),
                                  iconSize: 30.0,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Rewards(),
                                      ),
                                    );
                                  },
                                ),
                                GestureDetector(
                                  onLongPress: () {
                                    // Navegar a la pantalla de easter egg
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const EasterEggScreen(
                                          title: 'Swappy',
                                          description: 'La mejor mascota del mundo.',
                                          image: 'assets/images/Mascota_Swappy.png',
                                        ),
                                      ),
                                    );
                                  },
                                  onTap: () {
                                    // Navegar a la pantalla de favoritos
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
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
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
            // Filtro de estilos
            CategoryFilter(
              categories: _styles.toList(),
              selectedCategory: _selectedStyle,
              onCategorySelected: (style) {
                setState(() {
                  _selectedStyle = style;
                });
              },
            ),
            SizedBox(height: 25),
            Header(
                title: 'Catálogo',
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
