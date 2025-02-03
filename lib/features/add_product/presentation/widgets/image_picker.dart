import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:isolate';

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
  static const double MARGIN_PERCENTAGE =
      0.2; // Aumentado de 0.1 a 0.15 (15% de margen)
  static const int IMAGE_QUALITY = 85;

  Future<void> _processImageInBackground(XFile originalImage) async {
    // Crear un nuevo isolate para procesar la imagen
    final receivePort = ReceivePort();
    await Isolate.spawn(
      _processImage,
      [
        receivePort.sendPort,
        await originalImage.readAsBytes(),
        DISPLAY_WIDTH,
        DISPLAY_HEIGHT,
        MARGIN_PERCENTAGE,
        IMAGE_QUALITY
      ],
    );

    // Esperar el resultado del procesamiento
    final processedBytes = await receivePort.first as Uint8List;

    final processedImage = kIsWeb
        ? XFile.fromData(processedBytes)
        : await _saveToTempFile(processedBytes);

    if (widget.onProcessingComplete != null) {
      widget.onProcessingComplete!(processedImage);
    }
  }

  // Función estática para procesar la imagen en un isolate
  static void _processImage(List<dynamic> args) {
    SendPort sendPort = args[0];
    Uint8List bytes = args[1];
    double displayWidth = args[2];
    double displayHeight = args[3];
    double marginPercentage = args[4];
    int quality = args[5];

    // Decodificar y procesar la imagen
    final img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      sendPort.send(bytes); // Enviar la imagen original si hay error
      return;
    }

    // Calcular dimensiones con márgenes
    double availableWidth = displayWidth * (1 - 2 * marginPercentage);
    double availableHeight = displayHeight * (1 - 2 * marginPercentage);

    // Calcular las nuevas dimensiones manteniendo el aspect ratio
    double ratio = image.width / image.height;
    int targetWidth = availableWidth.toInt();
    int targetHeight = availableHeight.toInt();

    if (ratio > availableWidth / availableHeight) {
      targetHeight = (availableWidth / ratio).toInt();
    } else {
      targetWidth = (availableHeight * ratio).toInt();
    }

    // Redimensionar la imagen
    final img.Image resizedImage = img.copyResize(
      image,
      width: targetWidth,
      height: targetHeight,
      interpolation: img.Interpolation.linear,
    );

    // Crear una nueva imagen con fondo negro
    final img.Image finalImage = img.Image(
      width: displayWidth.toInt(),
      height: displayHeight.toInt(),
    );

    // Calcular la posición para centrar la imagen
    int x = ((displayWidth - targetWidth) / 2).toInt();
    int y = ((displayHeight - targetHeight) / 2).toInt();

    // Copiar la imagen redimensionada en el centro
    img.compositeImage(finalImage, resizedImage, dstX: x, dstY: y);

    // Convertir y enviar el resultado
    sendPort
        .send(Uint8List.fromList(img.encodeJpg(finalImage, quality: quality)));
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
        maxWidth: DISPLAY_WIDTH * 2, // Vista previa con calidad reducida
        maxHeight: DISPLAY_HEIGHT * 2,
        imageQuality: 60,
      );

      if (pickedFile != null) {
        // Mostrar inmediatamente la vista previa
        setState(() => _tempImage = pickedFile);
        widget.onImagePicked(pickedFile);

        // Procesar la imagen original en segundo plano
        _processImageInBackground(pickedFile);
      }
    } catch (e) {
      print('Error selecting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sidePadding = screenWidth *
        0.15; // Aumentado de 0.1 a 0.15 para más espacio en los lados

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
                label: const Text(
                  'Sube una foto',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
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
                child: Padding(
                  padding: EdgeInsets.all(DISPLAY_WIDTH * MARGIN_PERCENTAGE),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb
                        ? Image.network(
                            widget.pickedImage.path,
                            fit: BoxFit.contain,
                            width: DISPLAY_WIDTH * (1 - 2 * MARGIN_PERCENTAGE),
                            height:
                                DISPLAY_HEIGHT * (1 - 2 * MARGIN_PERCENTAGE),
                          )
                        : Image.file(
                            widget.pickedImage,
                            fit: BoxFit.contain,
                            width: DISPLAY_WIDTH * (1 - 2 * MARGIN_PERCENTAGE),
                            height:
                                DISPLAY_HEIGHT * (1 - 2 * MARGIN_PERCENTAGE),
                          ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
