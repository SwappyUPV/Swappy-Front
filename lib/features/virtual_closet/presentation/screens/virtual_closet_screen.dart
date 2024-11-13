import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

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

  int _activePageTop = 0;
  int _activePageMiddle = 0;
  int _activePageBottom = 0;

  final PageController _pageControllerTop = PageController(initialPage: 0);
  final PageController _pageControllerMiddle = PageController(initialPage: 0);
  final PageController _pageControllerBottom = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _fetchTopImages();
    _fetchMidImages();
    _fetchBotImages();
  }

  // Método para obtener imágenes desde Firestore con categorías "Vestidos", "Camisetas" y "Chaquetas"
  Future<void> _fetchTopImages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('clothes')
          .where('categoria', whereIn: ['Vestidos', 'Camisetas', 'Chaquetas'])
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

  // Método para obtener imágenes desde Firestore con categorías "Pantalones" y "Faldas"
  Future<void> _fetchMidImages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('clothes')
          .where('categoria', whereIn: ['Pantalones', 'Faldas'])
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

  // Método para obtener imágenes desde Firestore con categoría "Zapatos"
  Future<void> _fetchBotImages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('clothes')
          .where('categoria', isEqualTo: 'Zapatos')
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Primer carrusel (usa la lista _top)
          carouselWidget(_pageControllerTop, _activePageTop, _top, (value) {
            setState(() {
              _activePageTop = value;
            });
          }),

          // Segundo carrusel (usa la lista _mid)
          carouselWidget(_pageControllerMiddle, _activePageMiddle, _mid, (value) {
            setState(() {
              _activePageMiddle = value;
            });
          }),

          // Tercer carrusel (usa la lista _bot)
          carouselWidget(_pageControllerBottom, _activePageBottom, _bot, (value) {
            setState(() {
              _activePageBottom = value;
            });
          }),
        ],
      ),
    );
  }

  // Método para crear el widget del carrusel, ahora con lista de imágenes como parámetro
  Widget carouselWidget(PageController controller, int activePage, List<Widget> images, Function(int) onPageChanged) {
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
                    backgroundColor: activePage == index ? Colors.yellow : Colors.grey,
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
        fit: BoxFit.contain,  // Ajusta la imagen para que se vea completa
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
