import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  final PageController _pageControllerAccessories = PageController(initialPage: 0);
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
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              carouselWidget(
                _pageControllerAccessories,
                _activePageAccessories,
                _accessories,
                    (value) {
                  setState(() {
                    _activePageAccessories = value;
                  });
                },
              ),
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
            top: 10,
            right: 20,
            child: MyGarmentsButton(
              onPressed: _navigateToChangeClothes, // Usamos la nueva función para navegar
            ),
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
          height: MediaQuery.of(context).size.height / 5,
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

