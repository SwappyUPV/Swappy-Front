import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';
import '../../models/product.dart';
import 'components/add_to_cart.dart';
import 'components/color_and_size.dart';
import 'components/counter_with_fav_btn.dart';
import 'components/description.dart';
import 'components/product_title_with_image.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600; // Detecta si es móvil
          return Container(
            width: isMobile ? constraints.maxWidth * 0.90 : 500,
            height: isMobile
                ? MediaQuery.of(context).size.height * 0.90
                : MediaQuery.of(context).size.height * 0.75,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: <Widget>[
                MouseRegion(
                  onEnter: (_) => _showPreviewPopup(context, product),
                  onExit: (_) => _hidePreviewPopup(),
                  child: SizedBox(
                    height: isMobile ? 350 : 300,
                    child: ProductTitleWithImage(product: product),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(kDefaultPaddin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ColorAndSize(product: product),
                        const SizedBox(height: kDefaultPaddin / 2),
                        Description(product: product),
                        const SizedBox(height: kDefaultPaddin / 2),
                        const CounterWithFavBtn(),
                        const SizedBox(height: kDefaultPaddin / 2),
                        AddToCart(product: product),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPreviewPopup(BuildContext context, Product product) {
    // Crear el popup como un Overlay
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 100.0, // Posición X del popup
        top: 100.0, // Posición Y del popup
        child: Material(
          child: Container(
            width: 200, // Ancho del popup
            height: 100, // Alto del popup
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(product.description),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(overlayEntry);
  }

  void _hidePreviewPopup() {
    // Aquí puedes ocultar el popup si es necesario
  }
}
