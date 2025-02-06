import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Necesario para kIsWeb
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Para realizar solicitudes multipart
import 'dart:io'; // Para trabajar con archivos de imagen
import 'package:image_picker/image_picker.dart'; // Si usas image_picker para seleccionar la imagen
import 'package:file_picker/file_picker.dart'; // Usado para seleccionar archivos en Web

class VirtualTryOnService {
  static const String _apiUrl = 'https://yisol-idm-vton.hf.space/api/predict';

  static Future<String?> tryOnClothesAndGetImageUrl(
      Uint8List personImageBytes, String clothesImageUrl) async {
    var clothesResponse = await http.get(Uri.parse(clothesImageUrl));
    if (clothesResponse.statusCode != 200) {
      print("Error descargando la imagen de la prenda");
      return "";
    }

    Uint8List clothesImageBytes = clothesResponse.bodyBytes;

    // Convertir la imagen de la prenda a PNG
    img.Image? image = img.decodeImage(clothesImageBytes);
    if (image == null) {
      print("Error al decodificar la imagen de la prenda");
      return "";
    }
    Uint8List pngBytes = Uint8List.fromList(img.encodePng(image));
    String clothesFileName = "converted_clothes.png";

    var uri = Uri.https(
        "try-on-clothes.p.rapidapi.com", "/portrait/editing/try-on-clothes");
    var request = http.MultipartRequest("POST", uri);

    request.headers.addAll({
      'x-rapidapi-key': "871410ef94msh6db4dc310d7d923p14f776jsna4303bde21e9",
      'x-rapidapi-host': "try-on-clothes.p.rapidapi.com",
    });

    request.fields['task_type'] = 'async';
    request.fields['clothes_type'] = 'upper_body';
    request.files.add(http.MultipartFile.fromBytes(
        'person_image', personImageBytes,
        filename: 'person_image'));
    request.files.add(http.MultipartFile.fromBytes('clothes_image', pngBytes,
        filename: clothesFileName));

    try {
      var response = await request.send();
      await Future.delayed(Duration(seconds: 5));
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        String taskId = jsonResponse['task_id'];
        print("Task ID: $taskId");

        await Future.delayed(Duration(seconds: 15));

        var taskResultResponse = await http.get(
          Uri.https("try-on-clothes.p.rapidapi.com",
              "/api/rapidapi/query-async-task-result", {"task_id": taskId}),
          headers: {
            'x-rapidapi-key':
                "871410ef94msh6db4dc310d7d923p14f776jsna4303bde21e9",
            'x-rapidapi-host': "try-on-clothes.p.rapidapi.com",
          },
        );

        print(taskResultResponse.body);

        if (taskResultResponse.statusCode == 200) {
          var taskResultData = jsonDecode(taskResultResponse.body);
          if (taskResultData['data'] != null &&
              taskResultData['data']['image'] != null) {
            // Retorna la URL de la imagen de la respuesta de la tarea
            String imageUrl = taskResultData['data']['image'];

            // Corregir la URL eliminando los caracteres de escape '\'
            String correctedImageUrl = imageUrl.replaceAll(r'\/', '/');
            print("Image URL: $correctedImageUrl");
            return correctedImageUrl;
          } else {
            print("No se encontró la URL de la imagen en la respuesta.");
            return null;
          }
        } else {
          print(
              "Error al obtener el resultado de la tarea asincrónica: ${taskResultResponse.statusCode}");
          return null;
        }
      } else {
        print("Error en la solicitud: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Request failed: $e");
      return null;
    }
  }

  static Future<String?> queryAsyncTaskResult(String taskId) async {
    var uri = Uri.https("try-on-clothes.p.rapidapi.com",
        "/api/rapidapi/query-async-task-result", {"task_id": taskId});

    try {
      var response = await http.get(uri, headers: {
        'x-rapidapi-key': "e74b3e8abfmshd437b375b1486fep15f172jsn8653ffba2102",
        'x-rapidapi-host': "try-on-clothes.p.rapidapi.com",
      });
      await Future.delayed(Duration(seconds: 15));
      if (response.statusCode == 200) {
        print("Task Result: ${response.body}");
        return response.body;
      } else {
        print("Error: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Request failed: $e");
    }
    return "";
  }

  static Future<String?>? getImageUrlFromResponse(String jsonResponse) {
    try {
      // Decodificar el JSON
      var decodedResponse = jsonDecode(jsonResponse);

      // Verificar si la respuesta contiene la clave 'data' y 'image'
      if (decodedResponse['data'] != null &&
          decodedResponse['data']['image'] != null) {
        return decodedResponse['data']['image']; // Retorna la URL de la imagen
      } else {
        print("No se encontró la URL de la imagen en la respuesta.");
        return null;
      }
    } catch (e) {
      print("Error al decodificar la respuesta: $e");
      return null;
    }
  }

  static Future<Uint8List?> getImageFromUrl(String imageUrl) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print("Error al obtener la imagen: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error al realizar la petición para obtener la imagen: $e");
      return null;
    }
  }

  // Función para seleccionar imagen de la galería en web y móvil
  static Future<Uint8List?> pickImage() async {
    if (kIsWeb) {
      // En Web, usar FilePicker para seleccionar imágenes
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        return result.files.single.bytes; // Devuelve la imagen seleccionada
      }
    } else {
      // En dispositivos móviles, usar ImagePicker
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return await pickedFile.readAsBytes(); // Devuelve la imagen seleccionada
      }
    }
    return null; // Si no se selecciona ninguna imagen
  }
}
