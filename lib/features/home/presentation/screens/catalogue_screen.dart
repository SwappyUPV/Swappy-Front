import 'package:flutter/material.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../virtual_closet/presentation/screens/virtual_closet_screen.dart';
import 'add_product_screen.dart';
import '../../../chat/presentation/screens/chat_screen.dart';
import 'package:pin/core/services/authentication_service.dart'; // Your AuthMethod class
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class Catalogue extends StatefulWidget {
  const Catalogue({super.key});

  @override
  CatalogueState createState() => CatalogueState();
}

class CatalogueState extends State<Catalogue> {
  int _selectedIndex = 0;
  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  bool _isLoggedIn = AuthMethod().getCurrentUser() != null;

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
    {
      'nombre': 'Pantalones Vaqueros',
      'precio': '39,99',
      'imagen': 'assets/pantalones.jpg',
      'categoria': 'Pantalones',
      'etiquetas': ['denim', 'casual', 'versátil'],
    },
    {
      'nombre': 'Falda Plisada',
      'precio': '24,99',
      'imagen': 'assets/falda.jpg',
      'categoria': 'Faldas',
      'etiquetas': ['elegante', 'oficina', 'otoño'],
    },
    {
      'nombre': 'Chaqueta de Cuero',
      'precio': '89,99',
      'imagen': 'assets/chaqueta.jpg',
      'categoria': 'Chaquetas',
      'etiquetas': ['rock', 'invierno', 'moda'],
    },
    {
      'nombre': 'Collar de Perlas',
      'precio': '19,99',
      'imagen': 'assets/collar.jpg',
      'categoria': 'Accesorios',
      'etiquetas': ['elegante', 'clásico', 'joyería'],
    },
    {
      'nombre': 'Camiseta de Rayas',
      'precio': '15,99',
      'imagen': 'assets/camiseta_rayas.jpg',
      'categoria': 'Camisetas',
      'etiquetas': ['casual', 'marinero', 'primavera'],
    },
    {
      'nombre': 'Vestido de Noche',
      'precio': '79,99',
      'imagen': 'assets/vestido_noche.jpg',
      'categoria': 'Vestidos',
      'etiquetas': ['fiesta', 'elegante', 'noche'],
    },
    {
      'nombre': 'Botas de Montaña',
      'precio': '69,99',
      'imagen': 'assets/botas.jpg',
      'categoria': 'Zapatos',
      'etiquetas': ['aventura', 'resistente', 'invierno'],
    },
    {
      'nombre': 'Pantalones de Yoga',
      'precio': '34,99',
      'imagen': 'assets/pantalones_yoga.jpg',
      'categoria': 'Pantalones',
      'etiquetas': ['deporte', 'cómodo', 'fitness'],
    },
    {
      'nombre': 'Falda Vaquera',
      'precio': '27,99',
      'imagen': 'assets/falda_vaquera.jpg',
      'categoria': 'Faldas',
      'etiquetas': ['casual', 'denim', 'verano'],
    },
    {
      'nombre': 'Chaqueta Bomber',
      'precio': '54,99',
      'imagen': 'assets/chaqueta_bomber.jpg',
      'categoria': 'Chaquetas',
      'etiquetas': ['urbano', 'moderno', 'otoño'],
    },
    {
      'nombre': 'Pulsera de Plata',
      'precio': '22,99',
      'imagen': 'assets/pulsera.jpg',
      'categoria': 'Accesorios',
      'etiquetas': ['joyería', 'elegante', 'regalo'],
    },
    {
      'nombre': 'Camiseta Estampada',
      'precio': '18,99',
      'imagen': 'assets/camiseta_estampada.jpg',
      'categoria': 'Camisetas',
      'etiquetas': ['colorido', 'verano', 'juvenil'],
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
          SizedBox(
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
            case 2:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessagingPage(
                        user: const types.User(
                      id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
                      firstName: 'Usuario',
                      imageUrl: 'assets/images/FriendlyUser.jpg',
                    )),
                  ));
          }
        },
      ),
    );
  }
}

class CatalogueGrid extends StatelessWidget {
  final List<Map<String, dynamic>> filteredCatalogo;

  const CatalogueGrid({super.key, required this.filteredCatalogo});

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
