import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 5, left: 15),
                      child: Column(children: [
                        // "RENUEVA" alineado a la izquierda
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'On Trend',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontFamily: 'UrbaneMedium',
                            ),
                          ),
                        ),
                      ])),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: SvgPicture.asset(
                        'assets/icons/Linea5.svg', // Ruta del SVG
                        height: 20.0, // Tamaño opcional
                        width: 20.0,
                        semanticsLabel: 'Mi ícono', // Etiqueta accesible
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 0, left: 15),
                  child: Column(children: [
                    // "RENUEVA" alineado a la izquierda
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Los estilos que están arrasando',
                          style: GoogleFonts.openSans(
                            textStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        )),
                  ])),
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
