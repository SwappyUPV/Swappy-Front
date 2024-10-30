import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'package:pin/features/exchanges/models/Product.dart';

class ProductTitleWithImage extends StatefulWidget {
  const ProductTitleWithImage({super.key, required this.product});

  final Product product;

  @override
  _ProductTitleWithImageState createState() => _ProductTitleWithImageState();
}

class _ProductTitleWithImageState extends State<ProductTitleWithImage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Aristocratic Hand Bag",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                widget.product.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: kDefaultPaddin),
              const SizedBox(
                  height:
                      kDefaultPaddin), // Espacio entre "Casi Nuevo" y las imágenes
              // PageView for images
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.5, // 50% del tamaño de la ventana
                child: PageView(
                  controller: _pageController,
                  children: [
                    Align(
                      alignment: Alignment
                          .bottomCenter, // Alinear la imagen por la parte inferior
                      child: Image.asset(
                        'assets/images/product1.png',
                        fit: BoxFit.contain, // Mantener proporciones
                      ),
                    ),
                    Align(
                      alignment: Alignment
                          .bottomCenter, // Alinear la imagen por la parte inferior
                      child: Image.asset(
                        'assets/images/product2.png',
                        fit: BoxFit.contain, // Mantener proporciones
                      ),
                    ),
                    Align(
                      alignment: Alignment
                          .bottomCenter, // Alinear la imagen por la parte inferior
                      child: Image.asset(
                        'assets/images/product3.png',
                        fit: BoxFit.contain, // Mantener proporciones
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5), // Espacio entre la imagen y los puntos
              // Dot indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color.fromARGB(255, 0, 0, 0)
                          : const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 50,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Text(
                    "Casi Nuevo",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.03,
                  height: 50,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
