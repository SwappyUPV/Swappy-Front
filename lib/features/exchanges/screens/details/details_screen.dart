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
import 'package:image_picker/image_picker.dart';
import 'components/VirtualTryOnResult.dart';
import 'components/Details_app_bar.dart';
import 'package:pin/features/add_product/presentation/screens/upload_product_screen.dart';

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

  Future<void> _pickImageAndTryOn() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isTryingOn = true;
        _tryOnResult = null;
      });

      try {
        final String selectedImagePath = pickedFile.path;
        debugPrint('Iniciando prueba virtual con la imagen seleccionada: $selectedImagePath');
        debugPrint('Imagen de prenda: ${widget.product.image}');

        // Convertir la imagen seleccionada a bytes (Uint8List)
        Uint8List selectedImageBytes = await pickedFile.readAsBytes();

        // Ahora llamamos al servicio con la imagen seleccionada y la imagen de la ropa
        String? resultImageUrl = await VirtualTryOnService.tryOnClothesAndGetImageUrl(
          selectedImageBytes, // Pasamos los bytes de la imagen seleccionada
          widget.product.image, // Pasamos la URL de la imagen de la ropa
        );

        if (resultImageUrl != null) {
          // Ahora obtenemos la imagen desde la URL
          Uint8List? resultImage = await VirtualTryOnService.getImageFromUrl(resultImageUrl);

          if (resultImage != null) {
            // Cuando la imagen esté lista, navega a la nueva pantalla para mostrarla
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VirtualTryOnResultScreen(tryOnImage: resultImage),
              ),
            );
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error al obtener la imagen de la prueba virtual')),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al procesar la prueba virtual')),
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
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se seleccionó ninguna imagen')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ProductService productService = ProductService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DetailsAppBar(
        onIconPressed: () {
            Navigator.of(context).pop(); // Si fromExchange es true, hace un pop
        },

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
                      const SizedBox(height: kPadding),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isTryingOn ? null : _pickImageAndTryOn,
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
                                _isTryingOn ? 'Procesando...' : 'Prueba virtual',
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
                      const SizedBox(height: kPadding - 10),
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
                                  // Acción para modificar
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const UploadProductScreen(showModifyButton: true),
                                    ),
                                  );
                                },
                                child: const Text('Modificar'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
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
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: kPadding/2),
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