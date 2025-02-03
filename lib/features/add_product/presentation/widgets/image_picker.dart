import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class ImagePickerWidget extends StatefulWidget {
  final dynamic pickedImage;
  final Function(dynamic) onImagePicked;

  const ImagePickerWidget({
    super.key,
    required this.pickedImage,
    required this.onImagePicked,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  bool _isProcessing = false;

  // Dimensiones de visualización
  static const double DISPLAY_WIDTH = 400.0;
  static const double DISPLAY_HEIGHT = 650.0;
  static const int IMAGE_QUALITY = 85;

  Future<void> _processAndSaveImage(XFile originalImage) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final Uint8List bytes = await originalImage.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);

      if (image == null) return;

      // Calcular las nuevas dimensiones manteniendo el aspect ratio
      double ratio = image.width / image.height;
      int targetWidth = DISPLAY_WIDTH.toInt();
      int targetHeight = DISPLAY_HEIGHT.toInt();

      if (ratio > DISPLAY_WIDTH / DISPLAY_HEIGHT) {
        // Imagen más ancha que alta
        targetHeight = (DISPLAY_WIDTH / ratio).toInt();
      } else {
        // Imagen más alta que ancha
        targetWidth = (DISPLAY_HEIGHT * ratio).toInt();
      }

      // Redimensionar la imagen
      final img.Image resizedImage = img.copyResize(
        image,
        width: targetWidth,
        height: targetHeight,
        interpolation: img.Interpolation.linear,
      );

      // Crear una nueva imagen con fondo negro del tamaño del display
      final img.Image finalImage = img.Image(
        width: DISPLAY_WIDTH.toInt(),
        height: DISPLAY_HEIGHT.toInt(),
      );

      // Calcular la posición para centrar la imagen redimensionada
      int x = ((DISPLAY_WIDTH - targetWidth) / 2).toInt();
      int y = ((DISPLAY_HEIGHT - targetHeight) / 2).toInt();

      // Copiar la imagen redimensionada en el centro
      img.compositeImage(finalImage, resizedImage, dstX: x, dstY: y);

      // Convertir la imagen final a bytes
      final Uint8List processedBytes =
          Uint8List.fromList(img.encodeJpg(finalImage, quality: IMAGE_QUALITY));

      if (kIsWeb) {
        widget.onImagePicked(XFile.fromData(processedBytes));
      } else {
        final tempDir = await Directory.systemTemp.createTemp();
        final tempFile = File('${tempDir.path}/processed_image.jpg');
        await tempFile.writeAsBytes(processedBytes);
        widget.onImagePicked(tempFile);
      }
    } catch (e) {
      print('Error processing image: $e');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        await _processAndSaveImage(pickedFile);
      }
    } catch (e) {
      print('Error selecting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sidePadding = screenWidth * 0.1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sidePadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _pickImage,
                    icon: const Icon(Icons.add, size: 24),
                    label: Text(
                      _isProcessing ? 'Procesando...' : 'Sube una foto',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                  if (_isProcessing)
                    const Positioned(
                      right: 16,
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        if (widget.pickedImage != null)
          Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: sidePadding),
            child: Container(
              width: DISPLAY_WIDTH,
              height: DISPLAY_HEIGHT,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb
                      ? Image.network(
                          widget.pickedImage.path,
                          fit: BoxFit.contain,
                          width: DISPLAY_WIDTH,
                          height: DISPLAY_HEIGHT,
                        )
                      : Image.file(
                          widget.pickedImage,
                          fit: BoxFit.contain,
                          width: DISPLAY_WIDTH,
                          height: DISPLAY_HEIGHT,
                        ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
