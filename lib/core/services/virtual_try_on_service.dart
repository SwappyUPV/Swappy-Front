import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class VirtualTryOnService {
  static const String _apiUrl = 'https://yisol-idm-vton.hf.space/api/predict';

  static Future<Uint8List?> tryOnGarment({
    required String humanImageUrl,
    required String garmentImageUrl,
    required String garmentDescription,
    bool isChecked = true,
    bool isCheckedCrop = false,
    int denoiseSteps = 30,
    int seed = 42,
  }) async {
    try {
      debugPrint('Descargando imagen humana desde: $humanImageUrl');
      debugPrint('Descargando imagen de prenda desde: $garmentImageUrl');

      // Primero descargamos las imágenes para convertirlas a base64
      final humanResponse = await http
          .get(Uri.parse(humanImageUrl))
          .timeout(const Duration(seconds: 30));

      debugPrint(
          'Estado de respuesta imagen humana: ${humanResponse.statusCode}');
      if (humanResponse.statusCode != 200) {
        debugPrint('Error en imagen humana: ${humanResponse.body}');
        throw Exception(
            'Error al descargar la imagen humana: ${humanResponse.statusCode}');
      }

      final garmentResponse = await http
          .get(Uri.parse(garmentImageUrl))
          .timeout(const Duration(seconds: 30));

      debugPrint(
          'Estado de respuesta imagen prenda: ${garmentResponse.statusCode}');
      if (garmentResponse.statusCode != 200) {
        debugPrint('Error en imagen prenda: ${garmentResponse.body}');
        throw Exception(
            'Error al descargar la imagen de la prenda: ${garmentResponse.statusCode}');
      }

      // Procesar la imagen de la prenda para remover el fondo negro
      final garmentImage = img.decodeImage(garmentResponse.bodyBytes);
      if (garmentImage != null) {
        // Convertir píxeles negros a transparentes
        for (var i = 0; i < garmentImage.length; i++) {
          final x = i % garmentImage.width;
          final y = i ~/ garmentImage.width;
          final pixel = garmentImage.getPixel(x, y);
          final r = pixel.r.toInt();
          final g = pixel.g.toInt();
          final b = pixel.b.toInt();

          // Si el pixel es negro o muy cercano a negro
          if (r < 30 && g < 30 && b < 30) {
            garmentImage.setPixel(
                x, y, img.ColorRgba8(r, g, b, 0)); // Hacer transparente
          }
        }

        // Codificar la imagen procesada como PNG (para mantener la transparencia)
        final processedGarmentBytes = img.encodePng(garmentImage);
        final garmentBase64 = base64Encode(processedGarmentBytes);
        final humanBase64 = base64Encode(humanResponse.bodyBytes);

        debugPrint('Imágenes convertidas a base64 correctamente');
        debugPrint('Enviando solicitud a la API...');

        final response = await http
            .post(
              Uri.parse(_apiUrl),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: jsonEncode({
                "fn_index": 0,
                "data": [
                  {"image": humanBase64, "mask": null},
                  {"image": garmentBase64, "mask": null},
                  garmentDescription,
                  isChecked,
                  isCheckedCrop,
                  denoiseSteps,
                  seed
                ],
                "session_hash": DateTime.now().millisecondsSinceEpoch.toString()
              }),
            )
            .timeout(const Duration(minutes: 2));

        debugPrint('Respuesta recibida. Estado: ${response.statusCode}');

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          debugPrint('Response data: $responseData');

          if (responseData['data'] != null && responseData['data'].length > 0) {
            final outputImageBase64 = responseData['data'][0];
            return base64Decode(outputImageBase64.split(',').last);
          } else {
            throw Exception('Respuesta vacía del servidor');
          }
        } else {
          debugPrint('Error response: ${response.body}');
          throw Exception(
              'Error al procesar la imagen: ${response.statusCode} - ${response.body}');
        }
      } else {
        throw Exception('Error al procesar la imagen de la prenda');
      }
    } catch (e) {
      debugPrint('Error en VirtualTryOnService: $e');
      return null;
    }
  }
}
