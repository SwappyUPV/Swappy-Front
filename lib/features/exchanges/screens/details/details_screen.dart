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

  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Fondo transparente para el blur
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600; // Detecta si es móvil
          return Container(
            width:
                isMobile ? constraints.maxWidth * 0.90 : 500, // Ajusta el ancho
            height: isMobile
                ? MediaQuery.of(context).size.height * 0.90
                : MediaQuery.of(context).size.height * 0.75, // Ajusta la altura
            margin: const EdgeInsets.symmetric(
                horizontal: 20), // Margen del diálogo
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9), // Fondo traslúcido
              borderRadius: BorderRadius.circular(24), // Esquinas redondeadas
            ),
            child: Column(
              children: <Widget>[
                // Imagen ocupa más espacio
                SizedBox(
                  height: isMobile ? 350 : 300, // Altura de la imagen
                  child: ProductTitleWithImage(product: product),
                ),
                // Sección de detalles
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
}
