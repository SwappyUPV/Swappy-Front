import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';
import 'components/characteristics.dart';
import 'components/description.dart';
import 'components/product_title_with_image.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';
import 'package:pin/core/services/product.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    super.key,
    required this.product,
    this.showActionButtons = false,
    this.showEditButtons = false,
  });

  final Product product;
  final bool showActionButtons;
  final bool showEditButtons;
  
  @override
  Widget build(BuildContext context) {
    final ProductService productService = ProductService(); // Instancia del servicio
    final Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: product.color,
      appBar: AppBar(
        backgroundColor: product.color,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/back.svg',
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
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
                        if (showActionButtons) ...[
                          const SizedBox(height: kDefaultPaddin),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Implementar lógica de compra
                                  },
                                  child: const Text('COMPRAR'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Exchanges(
                                          selectedProduct: product,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('SWAP'),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (showEditButtons) ...[
                          const SizedBox(height: kDefaultPaddin),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Acción para probar
                                  },
                                  child: const Text('Probar'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Acción para modificar
                                  },
                                  child: const Text('Modificar'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              String result = await productService.deleteProduct(product.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result)),
                              );
                              Navigator.pop(context, true); // Devuelve "true" al cerrar la pantalla
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Borrar'),
                          ),
                        ],
                        TextButton(
                          onPressed: () {
                            // Acción a realizar al presionar el botón
                          },
                          child: const Text(
                            "Más información",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
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