import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:pin/features/virtual_closet/presentation/screens/change_clothes_screen.dart';
import 'package:pin/features/virtual_closet/presentation/widgets/virtual_closet_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Para manejar JSON
import 'package:pin/features/virtual_closet/presentation/widgets/help_button.dart';
import 'package:pin/features/virtual_closet/presentation/widgets/MyGarmentsButton.dart';
import 'package:pin/features/virtual_closet/presentation/widgets/CameraButton.dart';

class VirtualClosetScreen extends StatefulWidget {
  const VirtualClosetScreen({super.key});

  @override
  _VirtualClosetScreenState createState() => _VirtualClosetScreenState();
}

class _VirtualClosetScreenState extends State<VirtualClosetScreen> {
  List<Widget> _mid = [];
  List<Widget> _top = [];
  List<Widget> _bot = [];
  List<Widget> _accessories = [];
  bool _isLoading = true;
  String? _userId; // Variable para almacenar el ID del usuario

  int _activePageAccessories = 0;
  int _activePageTop = 0;
  int _activePageMiddle = 0;
  int _activePageBottom = 0;

  final PageController _pageControllerAccessories =
      PageController(initialPage: 0);
  final PageController _pageControllerTop = PageController(initialPage: 0);
  final PageController _pageControllerMiddle = PageController(initialPage: 0);
  final PageController _pageControllerBottom = PageController(initialPage: 0);

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
        _fetchAccessoriesImages();
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

  Future<void> _fetchAccessoriesImages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('clothes')
          .where('categoria', whereIn: ['Accesorios'])
          .where('userId', whereIn: [_userId])
          .where('enCloset', isEqualTo: true)
          .get();

      final List<Widget> pages = snapshot.docs.map((doc) {
        return ImagePlaceHolder(imagePath: doc['imagen']);
      }).toList();

      setState(() {
        _accessories = pages;
        _isLoading = false;
      });
    } catch (e) {
      print("Error al obtener datos de Firebase (Top): $e");
    }
  }

  Future<void> _fetchTopImages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('clothes')
          .where('categoria', whereIn: ['Vestidos', 'Camisetas', 'Chaquetas'])
          .where('userId', whereIn: [_userId])
          .where('enCloset', isEqualTo: true)
          .get();

      final List<Widget> pages = snapshot.docs.map((doc) {
        return ImagePlaceHolder(imagePath: doc['imagen']);
      }).toList();

      setState(() {
        _top = pages;
        _isLoading = false;
      });
    } catch (e) {
      print("Error al obtener datos de Firebase (Top): $e");
    }
  }

  Future<void> _fetchMidImages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('clothes')
          .where('categoria', whereIn: ['Pantalones', 'Faldas'])
          .where('userId', whereIn: [_userId])
          .where('enCloset', isEqualTo: true)
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
          .where('enCloset', isEqualTo: true)
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
  }

  // Método para navegar a la pantalla de productos y recargar cuando se regresa
  void _navigateToChangeClothes() async {
    final bool shouldReload = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangeClothes(fromExchange: false),
      ),
    );

    // Si el valor pasado es 'true', recargamos los datos
    if (shouldReload) {
      _fetchAccessoriesImages();
      _fetchTopImages();
      _fetchMidImages();
      _fetchBotImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VirtualClosetAppBar(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height -
                                (MediaQuery.of(context).padding.top +
                                    kToolbarHeight +
                                    20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildSection(
                                "Accesorios",
                                _pageControllerAccessories,
                                _activePageAccessories,
                                _accessories,
                                (value) {
                                  setState(
                                      () => _activePageAccessories = value);
                                },
                                isAccessories: true,
                              ),
                              _buildSection(
                                "Parte Superior",
                                _pageControllerTop,
                                _activePageTop,
                                _top,
                                (value) {
                                  setState(() => _activePageTop = value);
                                },
                              ),
                              _buildSection(
                                "Parte Inferior",
                                _pageControllerMiddle,
                                _activePageMiddle,
                                _mid,
                                (value) {
                                  setState(() => _activePageMiddle = value);
                                },
                              ),
                              _buildSection(
                                "Calzado",
                                _pageControllerBottom,
                                _activePageBottom,
                                _bot,
                                (value) {
                                  setState(() => _activePageBottom = value);
                                },
                                isShoes: true,
                              ),
                              // Espacio adicional al final para evitar que el último elemento quede cortado
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          // Botones flotantes
          Positioned(
            top: 10,
            right: 20,
            child: MyGarmentsButton(onPressed: _navigateToChangeClothes),
          ),
          const Positioned(
            bottom: 10,
            right: 20,
            child: HelpButton(),
          ),
          const Positioned(
            top: 10,
            left: 20,
            child: CameraButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    PageController controller,
    int activePage,
    List<Widget> images,
    Function(int) onPageChanged, {
    bool isAccessories = false,
    bool isShoes = false,
  }) {
    // Ajustamos las proporciones para que sean más pequeñas
    double sectionHeight;
    double scale;

    if (isAccessories) {
      sectionHeight =
          MediaQuery.of(context).size.height * 0.12; // Reducido de 0.15
      scale = 0.45; // Reducido de 0.5
    } else if (isShoes) {
      sectionHeight =
          MediaQuery.of(context).size.height * 0.15; // Reducido de 0.18
      scale = 0.65; // Reducido de 0.7
    } else {
      sectionHeight =
          MediaQuery.of(context).size.height * 0.2; // Reducido de 0.25
      scale = 0.9; // Reducido de 1.0
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 4), // Reducido el padding vertical
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          height: sectionHeight,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Stack(
            children: [
              PageView.builder(
                controller: controller,
                itemCount: images.length,
                onPageChanged: onPageChanged,
                physics: const BouncingScrollPhysics(),
                pageSnapping: true,
                dragStartBehavior: DragStartBehavior.down,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! > 0) {
                        controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else if (details.primaryVelocity! < 0) {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: images[index],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Indicadores de navegación
              if (images.length > 1) ...[
                // Indicador izquierdo
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return (controller.hasClients &&
                            controller.page?.floor() != 0)
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                controller.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chevron_left,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
                // Indicador derecho
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return (controller.hasClients &&
                            controller.page?.floor() != images.length - 1)
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ],
            ],
          ),
        ),
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
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade100,
            child: const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey,
                size: 40,
              ),
            ),
          );
        },
      );
    } else {
      return Container(
        color: Colors.grey.shade100,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
            size: 40,
          ),
        ),
      );
    }
  }
}
