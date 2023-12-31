/// Alejandro Sánchez Monzón
/// Mireya Sánchez Pinzón
/// Rubén García-Redondo Marín

import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// Clase que gestiona el almacenamiento de imágenes.
class StorageProvider with ChangeNotifier {
  /// Token de autenticación.
  final String? _token;

  StorageProvider(this._token);

  /// Url base de la API.
  String baseUrl = 'http://app.iesluisvives.org:1212';

  /// Función que sube una imagen de un espacio.
  Future<String> uploadSpaceImage(PickedFile imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/spaces/storage'),
    );

    request.headers['Authorization'] = 'Bearer $_token';

    Uint8List imageBytes = await imageFile.readAsBytes();

    final file = http.MultipartFile.fromBytes(
      'image',
      imageBytes,
      filename: 'space.png',
      contentType: MediaType('image', 'png'),
    );

    request.files.add(file);

    final response = await request.send();

    if (response.statusCode == 201) {
      final data = await response.stream.bytesToString();
      final json = jsonDecode(data);
      final fileName = json['data']['fileName'];

      return fileName.split('.')[0];
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  /// Función que sube una imagen de un usuario.
  Future<String> uploadUserImage(PickedFile imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/users/storage'),
    );

    request.headers['Authorization'] = 'Bearer $_token';

    Uint8List imageBytes = await imageFile.readAsBytes();

    final file = http.MultipartFile.fromBytes(
      'image',
      imageBytes,
      filename: 'user.png',
      contentType: MediaType('image', 'png'),
    );

    request.files.add(file);

    final response = await request.send();

    if (response.statusCode == 201) {
      final data = await response.stream.bytesToString();
      final json = jsonDecode(data);
      final fileName = json['data']['fileName'];

      return fileName.split('.')[0];
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}