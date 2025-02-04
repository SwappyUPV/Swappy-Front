import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pin/core/services/virtual_try_on_service.dart';
import 'package:pin/core/constants/constants.dart';

import '../../constants.dart';
import 'components/characteristics.dart';
import 'components/description.dart';
import 'components/product_title_with_image.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';
import 'package:pin/core/services/product.dart';

class DetailsScreen extends StatefulWidget {
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
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  static const double kPadding = 16.0;
  bool _isTryingOn = false;
  Uint8List? _tryOnResult;

  Future<void> _tryOnVirtually() async {
    setState(() {
      _isTryingOn = true;
      _tryOnResult = null;
    });

    try {
      const String demoPersonImageUrl =
          "https://huggingface.co/spaces/yisol/IDM-VTON/resolve/main/demo_images/person.jpg";

      debugPrint('Iniciando prueba virtual con imagen: $demoPersonImageUrl');
      debugPrint('Imagen de prenda: ${widget.product.image}');

      final result = await VirtualTryOnService.tryOnGarment(
        humanImageUrl: demoPersonImageUrl,
        garmentImageUrl: widget.product.image,
        garmentDescription: widget.product.title,
        isChecked: true,
        isCheckedCrop: false,
        denoiseSteps: 30,
        seed: 42,
      );

      if (result != null) {
        setState(() {
          _tryOnResult = result;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Error al procesar la prueba virtual')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error en prueba virtual: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al procesar la prueba virtual')),
        );
      }
    } finally {
      setState(() {
        _isTryingOn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProductService productService = ProductService();
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: widget.product.color,
      appBar: AppBar(
        backgroundColor: widget.product.color,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/back.svg',
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ProductTitleWithImage(product: widget.product),
                Container(
                  margin: const EdgeInsets.only(top: kPadding),
                  padding: const EdgeInsets.only(
                    top: kPadding * 2,
                    left: kPadding,
                    right: kPadding,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Description(product: widget.product),
                      const SizedBox(height: kPadding),
                      Characteristics(product: widget.product),
                      const SizedBox(height: kPadding * 2),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isTryingOn ? null : _tryOnVirtually,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: const BorderSide(color: Colors.black),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kPadding,
                                  vertical: kPadding / 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                _isTryingOn
                                    ? 'Procesando...'
                                    : 'Probar virtualmente',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_tryOnResult != null) ...[
                        const SizedBox(height: kPadding),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            _tryOnResult!,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: 400,
                          ),
                        ),
                      ],
                      const SizedBox(height: kPadding * 2),
                      if (widget.showActionButtons) ...[
                        const SizedBox(height: kPadding),
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
                                        selectedProduct: widget.product,
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
                      if (widget.showEditButtons) ...[
                        const SizedBox(height: kPadding),
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
                            String result = await productService
                                .deleteProduct(widget.product.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result)),
                            );
                            Navigator.pop(context,
                                true); // Devuelve "true" al cerrar la pantalla
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
              ],
            ),
          ),
          if (_isTryingOn)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
