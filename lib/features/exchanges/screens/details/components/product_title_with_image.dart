import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
    // Determinar las imágenes que se mostrarán
    final List<Widget> imageWidgets =
        widget.product.image != null && widget.product.image.isNotEmpty
            ? [
                Container(
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.network(
                      widget.product.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ]
            : [
                Container(
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/images/product1.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/images/product2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/images/product3.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ];

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
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        MediaQuery.of(context).size.width > 600 ? 28 : 20),
              ),
              const SizedBox(height: kDefaultPaddin),
              const SizedBox(height: kDefaultPaddin),
              // PageView for images
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                height: MediaQuery.of(context).size.height * 0.5,
                child: PageView(
                  controller: _pageController,
                  children: imageWidgets,
                ),
              ),
              const SizedBox(height: 5),
              // Dot indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(imageWidgets.length, (index) {
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
        ],
      ),
    );
  }
}
