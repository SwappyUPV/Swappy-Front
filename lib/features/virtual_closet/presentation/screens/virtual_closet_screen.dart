import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pin/features/virtual_closet/presentation/screens/change_clothes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Para manejar JSON

class VirtualCloset extends StatefulWidget {
  final bool
      fromExchange; // Atributo para determinar si se viene de un intercambio

  const VirtualCloset({super.key, required this.fromExchange});

  @override
  _VirtualClosetState createState() => _VirtualClosetState();
}

<<<<<<< Updated upstream
class _VirtualClosetState extends State<VirtualCloset> {
  List<Widget> _mid = [];
  List<Widget> _top = [];
  List<Widget> _bot = [];
  bool _isLoading = true;
  String? _userId; // Variable para almacenar el ID del usuario

  int _activePageTop = 0;
  int _activePageMiddle = 0;
  int _activePageBottom = 0;

  final PageController _pageControllerTop = PageController(initialPage: 0);
  final PageController _pageControllerMiddle = PageController(initialPage: 0);
  final PageController _pageControllerBottom = PageController(initialPage: 0);
=======
class _VirtualClosetScreenState extends State<VirtualCloset> {
  final ChatService2 _chatService2 = ChatService2();
  final CatalogService _catalogService = CatalogService();
  String? _cachedUserId;
  Map<String, List<Product>> _categorizedClothes = {};
  List<Product> _selectedProducts = []; // Lista de productos seleccionados
>>>>>>> Stashed changes

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Cargar el ID del usuario antes de cargar imágenes
  }

  Future<void> _loadUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userModelJson = prefs.getString('userModel');

      if (userModelJson != null) {
        Map<String, dynamic> userModelMap = jsonDecode(userModelJson);
        if (mounted) {
          setState(() {
            _userId = userModelMap['uid']; // Asigna el ID del usuario
          });
          print("User ID: $_userId");
        }
        // Ahora puedes usar _userId para consultas específicas si es necesario
        _fetchTopImages();
        _fetchMidImages();
        _fetchBotImages();
      } else {
        print("No user data found");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print("Error loading user ID: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchTopImages() async {
    try {
<<<<<<< Updated upstream
      final snapshot = await FirebaseFirestore.instance
          .collection('clothes')
          .where('categoria', whereIn: ['Vestidos', 'Camisetas', 'Chaquetas'])
          .where('userId', whereIn: [_userId])
          .get();

      final List<Widget> pages = snapshot.docs.map((doc) {
        return ImagePlaceHolder(imagePath: doc['imagen']);
      }).toList();

      setState(() {
        _top = pages;
        _isLoading = false;
=======
      List<Product> clothes = await _catalogService.getClothByUserId(userId);
      Map<String, List<Product>> categorizedClothes = {};
      for (var product in clothes) {
        if (categorizedClothes[product.category] == null) {
          categorizedClothes[product.category] = [];
        }
        categorizedClothes[product.category]!.add(product);
      }

      setState(() {
        _categorizedClothes = categorizedClothes;
>>>>>>> Stashed changes
      });
    } catch (e) {
      print("Error al obtener datos de Firebase (Top): $e");
    }
  }

<<<<<<< Updated upstream
  Future<void> _fetchMidImages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('clothes')
          .where('categoria', whereIn: ['Pantalones', 'Faldas'])
          .where('userId', whereIn: [_userId])
          .get();

      final List<Widget> pages = snapshot.docs.map((doc) {
        return ImagePlaceHolder(imagePath: doc['imagen']);
      }).toList();

      setState(() {
        _mid = pages;
        _isLoading = false;
      });
    } catch (e) {
      print("Error al obtener datos de Firebase (Mid): $e");
    }
  }

  Future<void> _fetchBotImages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('clothes')
          .where('categoria', isEqualTo: 'Zapatos')
          .where('userId', whereIn: [_userId])
          .get();

      final List<Widget> pages = snapshot.docs.map((doc) {
        return ImagePlaceHolder(imagePath: doc['imagen']);
      }).toList();

      setState(() {
        _bot = pages;
        _isLoading = false;
      });
    } catch (e) {
      print("Error al obtener datos de Firebase (Bot): $e");
    }
=======
  void _toggleProductSelection(Product product) {
    setState(() {
      if (_selectedProducts.contains(product)) {
        _selectedProducts.remove(product);
      } else {
        _selectedProducts.add(product);
      }
    });
  }

  void _confirmSelection() {
    Navigator.pop(
        context, _selectedProducts); // Devuelve los productos seleccionados
>>>>>>> Stashed changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
      appBar: AppBar(
        title: const Text('Armario Virtual'),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              carouselWidget(
                _pageControllerTop,
                _activePageTop,
                _top,
                    (value) {
                  setState(() {
                    _activePageTop = value;
                  });
                },
              ),
              carouselWidget(
                _pageControllerMiddle,
                _activePageMiddle,
                _mid,
                    (value) {
                  setState(() {
                    _activePageMiddle = value;
                  });
                },
              ),
              carouselWidget(
                _pageControllerBottom,
                _activePageBottom,
                _bot,
                    (value) {
                  setState(() {
                    _activePageBottom = value;
                  });
                },
              ),
            ],
          ),
          // Botón flotante en la esquina superior derecha
          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangeClothes()),
                );
              },
              backgroundColor: Colors.blue,
              mini: true, // Botón pequeño
              child: const Icon(Icons.more_vert, size: 20),
            ),
          ),
=======
      appBar: AppBar(title: const Text("Armario Virtual")),
      body: Stack(
        children: [
          _categorizedClothes.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _categorizedClothes.entries.map((entry) {
                      final category = entry.key;
                      final products = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                final isSelected =
                                    _selectedProducts.contains(product);

                                return GestureDetector(
                                  onTap: widget.fromExchange
                                      ? () => _toggleProductSelection(product)
                                      : null, // Solo seleccionable si fromExchange es true
                                  child: Container(
                                    width: 120,
                                    margin: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Flexible(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              product.image,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(product.title,
                                            textAlign: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
          if (widget.fromExchange && _selectedProducts.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _confirmSelection,
                    child: const Text("Confirmar y añadir prendas"),
                  ),
                  const SizedBox(
                      height: 100), // Espacio adicional debajo del botón
                ],
              ),
            ),
>>>>>>> Stashed changes
        ],
      ),
    );
  }
<<<<<<< Updated upstream



  Widget carouselWidget(
      PageController controller,
      int activePage,
      List<Widget> images,
      Function(int) onPageChanged,
      ) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 4,
          child: PageView.builder(
            controller: controller,
            itemCount: images.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return images[index];
            },
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              images.length,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () {
                    controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor:
                    activePage == index ? Colors.yellow : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ImagePlaceHolder extends StatelessWidget {
  final String? imagePath;
  const ImagePlaceHolder({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return Image.network(
        imagePath!,
        fit: BoxFit.contain,
      );
    } else {
      return Container(
        color: Colors.grey.shade300,
        child: const Center(
          child: Text(
            'Image not available',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      );
    }
  }
}

=======
}
>>>>>>> Stashed changes
