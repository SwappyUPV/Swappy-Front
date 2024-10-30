import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import 'components/characteristics.dart';
import 'components/description.dart';
import 'components/product_title_with_image.dart';
import 'package:pin/features/exchanges/models/Product.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: product.color,
      appBar: AppBar(
        backgroundColor: product.color,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/back.svg',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.5),
                    padding: EdgeInsets.only(
                      top: size.height * 0.15,
                      right: 25,
                      left: 25,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Characteristics(product: product),
                        const SizedBox(height: kDefaultPaddin / 2),
                        Description(product: product),
                        const SizedBox(height: kDefaultPaddin / 2),
                        // Botón de "Más información"
                        TextButton(
                          onPressed: () {
                            // Acción a realizar al presionar el botón
                          },
                          child: const Text(
                            "Más información",
                            style: TextStyle(
                              color: Colors.grey, // Color gris
                              fontSize:
                                  16, // Ajusta el tamaño de la fuente si es necesario
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: kDefaultPaddin /
                                2), // Espacio adicional si es necesario
                      ],
                    ),
                  ),
                  ProductTitleWithImage(product: product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
