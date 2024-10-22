import 'package:flutter/material.dart';
import '../../../../core/services/catalogue.dart';

class Catalogue extends StatefulWidget {
  const Catalogue({Key? key}) : super(key: key);

  @override
  _CatalogueState createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {
  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  List<Map<String, dynamic>> catalogoRopa = [];
  bool _isLoading = true;

  final CatalogService _catalogService = CatalogService();

  final List<String> categorias = [
    'Todos',
    'Camisetas',
    'Vestidos',
    'Pantalones',
    'Zapatos',
    'Faldas',
    'Chaquetas',
    'Accesorios',
  ];

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
    setState(() {
      catalogoRopa = clothes;
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('../../assets/swappy.png', height: 30),
            SizedBox(width: 10),
            Text('Catálogo', style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Pantalla de favoritos no implementada')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Busca ropa para intercambiar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 16),
                for (String categoria in categorias)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(categoria),
                      selected: _selectedCategory == categoria,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = categoria;
                        });
                      },
                      selectedColor: Colors.teal.shade100,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                SizedBox(width: 8),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : CatalogueGrid(filteredCatalogo: filteredCatalogo),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Catalogue()),
          );
        },
        label: Text('Intercambiar'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

class CatalogueGrid extends StatelessWidget {
  final List<Map<String, dynamic>> filteredCatalogo;

  const CatalogueGrid({Key? key, required this.filteredCatalogo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = constraints.maxWidth / 5;
        final double aspectRatio = itemWidth / (itemWidth * 1.5);

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: itemWidth,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: filteredCatalogo.length,
          itemBuilder: (context, index) {
            final item = filteredCatalogo[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        item['imagen'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['nombre'],
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${item['precio']}€',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
