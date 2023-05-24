import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/models/usuario.dart';
import 'package:http/http.dart' as http;

class UsuariosProvider with ChangeNotifier {
  String? _token;

  List<Usuario> _usuarios = [];

  List<Usuario> get usuarios => _usuarios;

  UsuariosProvider(this._token) {
    fetchUsuarios();
  }

  String baseUrl = 'http://magarcia.asuscomm.com:25546';

  Future<void> fetchUsuarios() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'),
          headers: {'Authorization': 'Bearer $_token'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['data'] as List<dynamic>;
        _usuarios = results
            .map((json) => Usuario(
                  uuid: json['uuid'],
                  name: json['name'],
                  username: json['username'],
                  email: json['email'],
                  password: json['password'],
                  avatar: json['avatar'],
                  userRole: List<String>.from(json['userRole']),
                  credits: json['credits'],
                  isActive: json['isActive'],
                ))
            .toList();

        notifyListeners();
      } else {
        throw Exception('Error al obtener los usuarios.');
      }
    } catch (e) {
      _usuarios = [];
      notifyListeners();
    }
  }

  Future<Usuario?> fetchUsuario(String uuid) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/$uuid'),
          headers: {'Authorization': 'Bearer $_token'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Usuario(
          uuid: data['uuid'],
          name: data['name'],
          username: data['username'],
          email: data['email'],
          password: data['password'],
          avatar: data['avatar'],
          userRole: List<String>.from(data['userRole']),
          credits: data['credits'],
          isActive: data['isActive'],
        );
      } else {
        throw Exception('Error al obtener el usuario.');
      }
    } catch (e) {
      return null;
    }
  }

  Future<Usuario?> register(Usuario usuario) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(usuario),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _usuarios.add(Usuario(
          uuid: data['user']['uuid'],
          name: data['user']['name'],
          username: data['user']['username'],
          email: data['user']['email'],
          password: data['user']['password'],
          avatar: data['user']['avatar'],
          userRole: List<String>.from(data['userRole']),
          credits: data['user']['credits'],
          isActive: data['user']['isActive'],
        ));
        _token = data['token'];

        notifyListeners();
      } else {
        throw Exception('Error al registrar el usuario.');
      }
    } catch (e) {
      return null;
    }

    return usuario;
  }

  Future<void> updateUsuario(String uuid) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$uuid'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _usuarios[_usuarios.indexWhere((element) => element.uuid == uuid)] =
            Usuario(
          uuid: data['uuid'],
          name: data['name'],
          username: data['username'],
          email: data['email'],
          password: data['password'],
          avatar: data['avatar'],
          userRole: List<String>.from(data['userRole']),
          credits: data['credits'],
          isActive: data['isActive'],
        );
        notifyListeners();
      } else {
        throw Exception('Error al actualizar el usuario.');
      }
    } catch (e) {
      return;
    }
  }

  Future<void> updateUsuarioActividad(String uuid, bool isActive) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/active/$uuid/$isActive'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _usuarios.firstWhere((element) => element.uuid == uuid).isActive =
            data['isActive'];
        notifyListeners();
      } else {
        throw Exception('Error al actualizar el usuario.');
      }
    } catch (e) {
      return;
    }
  }

  Future<void> updateUsuarioCreditos(String uuid, String creditos) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/credits/$uuid/$creditos'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _usuarios.firstWhere((element) => element.uuid == uuid).credits =
            data['credits'];
        notifyListeners();
      } else {
        throw Exception('Error al actualizar el usuario.');
      }
    } catch (e) {
      return;
    }
  }

  Future<void> updateMe() async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/me'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _usuarios.firstWhere((element) => element.uuid == data['uuid']).name =
            data['name'];
        _usuarios
            .firstWhere((element) => element.uuid == data['uuid'])
            .username = data['username'];
        _usuarios.firstWhere((element) => element.uuid == data['uuid']).email =
            data['email'];
        _usuarios
            .firstWhere((element) => element.uuid == data['uuid'])
            .password = data['password'];
        _usuarios.firstWhere((element) => element.uuid == data['uuid']).avatar =
            data['avatar'];
        _usuarios
            .firstWhere((element) => element.uuid == data['uuid'])
            .userRole = List<String>.from(data['userRole']);
        _usuarios
            .firstWhere((element) => element.uuid == data['uuid'])
            .credits = data['credits'];
        _usuarios
            .firstWhere((element) => element.uuid == data['uuid'])
            .isActive = data['isActive'];
        notifyListeners();
      } else {
        throw Exception('Error al actualizar el usuario.');
      }
    } catch (e) {
      return;
    }
  }

  Future<void> deleteUsuarios(String uuid) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$uuid'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        _usuarios.removeWhere((element) => element.uuid == uuid);
        notifyListeners();
      } else {
        throw Exception('Error al eliminar el usuario.');
      }
    } catch (e) {
      return;
    }
  }
}