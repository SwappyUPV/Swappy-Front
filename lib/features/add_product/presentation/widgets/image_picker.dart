import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb, compute;
import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class ImagePickerWidget extends StatefulWidget {
  final dynamic pickedImage;
  final Function(dynamic) onImagePicked;
  final Function(dynamic)? onProcessingComplete;

  const ImagePickerWidget({
    super.key,
    required this.pickedImage,
    required this.onImagePicked,
    this.onProcessingComplete,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  bool _isProcessing = false;
  XFile? _tempImage;

  // Dimensiones de visualización
  static const double DISPLAY_WIDTH = 250.0;
  static const double DISPLAY_HEIGHT = 400.0;
  static const double MARGIN_PERCENTAGE = 0.1;
  static const int IMAGE_QUALITY = 85;

  Future<void> _processImageInBackground(XFile originalImage) async {
    setState(() => _isProcessing = true);

    try {
      final bytes = await originalImage.readAsBytes();
      final processedBytes = await compute(_processImage, [
        bytes,
        DISPLAY_WIDTH,
        DISPLAY_HEIGHT,
        MARGIN_PERCENTAGE,
        IMAGE_QUALITY
      ]);

      final processedImage = kIsWeb
          ? XFile.fromData(processedBytes)
          : await _saveToTempFile(processedBytes);

      widget.onImagePicked(processedImage);

      if (widget.onProcessingComplete != null) {
        widget.onProcessingComplete!(processedImage);
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  static Uint8List _processImage(List<dynamic> args) {
    Uint8List bytes = args[0];
    double displayWidth = args[1];
    double displayHeight = args[2];
    double marginPercentage = args[3];
    int quality = args[4];

    final img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      return bytes;
    }

    double availableWidth = displayWidth * (1 - 2 * marginPercentage);
    double availableHeight = displayHeight * (1 - 2 * marginPercentage);

    double ratio = image.width / image.height;
    int targetWidth = availableWidth.toInt();
    int targetHeight = availableHeight.toInt();

    if (ratio > availableWidth / availableHeight) {
      targetHeight = (availableWidth / ratio).toInt();
    } else {
      targetWidth = (availableHeight * ratio).toInt();
    }

    final img.Image resizedImage = img.copyResize(
      image,
      width: targetWidth,
      height: targetHeight,
      interpolation: img.Interpolation.linear,
    );

    final img.Image finalImage = img.Image(
      width: displayWidth.toInt(),
      height: displayHeight.toInt(),
    );

    int x = ((displayWidth - targetWidth) / 2).toInt();
    int y = ((displayHeight - targetHeight) / 2).toInt();

    img.compositeImage(finalImage, resizedImage, dstX: x, dstY: y);

    return Uint8List.fromList(img.encodeJpg(finalImage, quality: quality));
  }

  Future<File> _saveToTempFile(Uint8List bytes) async {
    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File('${tempDir.path}/processed_image.jpg');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() => _isProcessing = true);
        // No actualizamos la imagen inmediatamente
        // Esperamos a que se procese
        await _processImageInBackground(pickedFile);
      }
    } catch (e) {
      print('Error selecting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sidePadding = screenWidth * 0.15;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sidePadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ElevatedButton.icon(
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
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              );
            },
          ),
        ),
        if (widget.pickedImage != null)
          Container(
            margin: const EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: sidePadding),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: DISPLAY_WIDTH,
                  height: DISPLAY_HEIGHT,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Padding(
                      padding:
                          EdgeInsets.all(DISPLAY_WIDTH * MARGIN_PERCENTAGE),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb
                            ? Image.network(
                                widget.pickedImage.path,
                                fit: BoxFit.contain,
                                width:
                                    DISPLAY_WIDTH * (1 - 2 * MARGIN_PERCENTAGE),
                                height: DISPLAY_HEIGHT *
                                    (1 - 2 * MARGIN_PERCENTAGE),
                              )
                            : Image.file(
                                widget.pickedImage,
                                fit: BoxFit.contain,
                                width:
                                    DISPLAY_WIDTH * (1 - 2 * MARGIN_PERCENTAGE),
                                height: DISPLAY_HEIGHT *
                                    (1 - 2 * MARGIN_PERCENTAGE),
                              ),
                      ),
                    ),
                  ),
                ),
                if (_isProcessing)
                  Container(
                    width: DISPLAY_WIDTH,
                    height: DISPLAY_HEIGHT,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Procesando...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'UrbaneMedium',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
