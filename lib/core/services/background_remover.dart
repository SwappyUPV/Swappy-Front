import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class BackgroundRemoverService {
  static const String _apiUrl = 'https://api.remove.bg/v1.0/removebg';
  static const String _apiKey = '5YDbrYttgjPMkcS24nxv5aRX';

  static Future<Uint8List?> removeBackground(Uint8List imageBytes) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_apiUrl));

      // Agregar la API key al header
      request.headers.addAll({
        'X-Api-Key': _apiKey,
      });

      // Agregar la imagen como archivo
      request.files.add(
        http.MultipartFile.fromBytes(
          'image_file',
          imageBytes,
          filename: 'image.jpg',
        ),
      );

      // Enviar la solicitud
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        debugPrint('Error response: ${response.body}');
        throw Exception(
            'Error al procesar la imagen: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error en BackgroundRemoverService: $e');
      return null;
    }
  }
}
