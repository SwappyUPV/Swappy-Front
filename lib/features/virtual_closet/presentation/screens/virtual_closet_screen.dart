import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pin/features/virtual_closet/presentation/screens/change_clothes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Para manejar JSON

class VirtualCloset extends StatefulWidget {
  const VirtualCloset({super.key});

  @override
  _VirtualClosetState createState() => _VirtualClosetState();
}

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

