import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:ui' as ui;
import 'dart:async'; // Import para usar Completer

class ChatController {
  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  Future<types.FileMessage?> selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      return types.FileMessage(
        author: _currentUser(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );
    }
    return null;
  }

  Future<types.ImageMessage?> selectImage() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();

      // Utilizamos un Completer para manejar el resultado asíncrono
      final completer = Completer<types.ImageMessage>();

      ui.decodeImageFromList(bytes, (image) {
        final imageMessage = types.ImageMessage(
          author: _currentUser(),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          height: image.height.toDouble(),
          id: randomString(),
          name: result.name,
          size: bytes.length,
          uri: result.path,
          width: image.width.toDouble(),
        );

        completer.complete(imageMessage); // Completa el Future con el mensaje
      });

      return completer.future; // Devuelve el Future que será completado
    }
    return null;
  }

  Future<void> handleFileTap(
    types.Message message,
    List<types.Message> messages,
    Function(void Function()) setState,
  ) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  types.TextMessage createTextMessage(types.User user, String text) {
    return types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: text,
    );
  }

  types.User _currentUser() {
    return const types.User(
      id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
      firstName: 'Usuario',
      imageUrl: 'https://example.com/profile_image.jpg',
    );
  }
}
