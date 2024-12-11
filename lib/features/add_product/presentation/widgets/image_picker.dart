import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:io';

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

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() => _isProcessing = true);

        try {
          var uri = Uri.parse('http://localhost:8000/remove-background');
          var request = http.MultipartRequest('POST', uri);

          if (kIsWeb) {
            List<int> bytes = await pickedFile.readAsBytes();
            request.files.add(
              http.MultipartFile.fromBytes(
                'image',
                bytes,
                filename: pickedFile.name,
              ),
            );
          } else {
            request.files.add(
              await http.MultipartFile.fromPath(
                'image',
                pickedFile.path,
              ),
            );
          }

          var streamedResponse = await request.send();
          var response = await http.Response.fromStream(streamedResponse);

          if (response.statusCode == 200) {
            if (kIsWeb) {
              // Para web, crear un Blob URL
              final blob = response.bodyBytes;
              widget.onImagePicked(blob);
            } else {
              // Para móvil, guardar en archivo temporal
              final tempDir = await Directory.systemTemp.createTemp();
              final tempFile = File('${tempDir.path}/processed_image.png');
              await tempFile.writeAsBytes(response.bodyBytes);
              widget.onImagePicked(tempFile);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Error al procesar la imagen: ${response.statusCode}'),
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al comunicarse con el servidor: $e'),
            ),
          );
        } finally {
          setState(() => _isProcessing = false);
        }
      }
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: _isProcessing ? null : _pickImage,
          icon: _isProcessing
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(Icons.image),
          label: Text(_isProcessing ? 'Procesando...' : 'Seleccionar Imagen'),
        ),
        if (widget.pickedImage != null)
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: kIsWeb
                ? (widget.pickedImage is List<int>
                    ? Image.memory(widget.pickedImage)
                    : Image.network(widget.pickedImage.path))
                : Image.file(widget.pickedImage),
          ),
      ],
    );
  }
}
