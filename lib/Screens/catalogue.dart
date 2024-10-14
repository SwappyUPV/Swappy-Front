import 'package:flutter/material.dart';
import 'profile.dart';
import 'log_in.dart';
import 'virtual_closet.dart';
import 'add_product.dart';
import 'chat.dart';

class Catalogue extends StatefulWidget {
  const Catalogue({Key? key}) : super(key: key);

  @override
  _CatalogueState createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {
  int _selectedIndex = 0;
  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  bool _isLoggedIn = false;

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

  final List<Map<String, dynamic>> catalogoRopa = [
    {
      'nombre': 'Camiseta Vintage',
      'precio': '17,00',
      'imagen': 'assets/camiseta.jpg',
      'categoria': 'Camisetas',
      'etiquetas': ['vintage', 'casual', 'verano'],
    },
    {
      'nombre': 'Vestido Floral',
      'precio': '29,99',
      'imagen': 'assets/vestido.jpg',
      'categoria': 'Vestidos',
      'etiquetas': ['floral', 'elegante', 'primavera'],
    },
    {
      'nombre': 'Zapatillas Deportivas',
      'precio': '59,99',
      'imagen': 'assets/zapatillas.jpg',
      'categoria': 'Zapatos',
      'etiquetas': ['deporte', 'cómodo', 'running'],
    },
  ];

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
          _isLoggedIn
              ? IconButton(
                  icon: Icon(Icons.person, color: Colors.black),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Profile()),
                    );
                  },
                )
              : TextButton(
                  child: Text('Iniciar sesión',
                      style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AddProduct()),
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
            child: CatalogueGrid(filteredCatalogo: filteredCatalogo),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Armario Virtual',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              // Ya estamos en la página del catálogo
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VirtualCloset()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessagingPage()),
              );
              break;
          }
        },
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
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    item['imagen'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['nombre'],
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${item['precio']}€',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
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
  }
}
