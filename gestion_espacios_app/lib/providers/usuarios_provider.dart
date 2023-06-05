import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/models/usuario.dart';
import 'package:http/http.dart' as http;

class UsuariosProvider with ChangeNotifier {
  String? _token;

  List<Usuario> _usuarios = [];
  Usuario _actualUsuario = Usuario(
    uuid: '',
    name: '',
    username: '',
    email: '',
    password: '',
    avatar: '',
    userRole: [],
    credits: 0,
    isActive: false,
  );

  List<Usuario> get usuarios => _usuarios;
  Usuario get actualUsuario => _actualUsuario;

  UsuariosProvider(this._token) {
    fetchUsuarios();
    fetchActualUsuario();
  }

  String baseUrl = 'http://app.iesluisvives.org:1212';

  Future<void> fetchUsuarios() async {
    final response = await http.get(Uri.parse('$baseUrl/users'),
        headers: {'Authorization': 'Bearer $_token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['data'] as List<dynamic>;
      _usuarios = results
          .map((usuario) => Usuario(
                uuid: usuario['uuid'],
                name: usuario['name'],
                username: usuario['username'],
                email: usuario['email'],
                password: usuario['password'],
                avatar: usuario['avatar'],
                userRole: List<String>.from(usuario['userRole']),
                credits: usuario['credits'],
                isActive: usuario['isActive'],
              ))
          .toList();

      notifyListeners();
    } else {
      _usuarios = [];
      notifyListeners();
    }
  }

  Future<Usuario?> fetchActualUsuario() async {
    final response = await http.get(Uri.parse('$baseUrl/users/me'),
        headers: {'Authorization': 'Bearer $_token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _actualUsuario = Usuario(
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
      return _actualUsuario;
    } else {
      return null;
    }
  }

  Future<Usuario?> fetchUsuario(String uuid) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$uuid'),
        headers: {'Authorization': 'Bearer $_token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var usuario = Usuario(
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
      return usuario;
    } else {
      return null;
    }
  }

  Future<void> register(Usuario usuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      _usuarios.add(Usuario(
        uuid: data['user']['uuid'],
        name: data['user']['name'],
        username: data['user']['username'],
        email: data['user']['email'],
        password: data['user']['password'],
        avatar: data['user']['avatar'],
        userRole: List<String>.from(data['user']['userRole']),
        credits: data['user']['credits'],
        isActive: data['user']['isActive'],
      ));
      _token = data['token'];

      notifyListeners();
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> updateUsuario(String uuid, Usuario usuario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$uuid'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(usuario.toJson()),
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
      throw Exception(response.body);
    }
  }

  Future<void> updateUsuarioActividad(String uuid, bool isActive) async {
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
      throw Exception(response.body);
    }
  }

  Future<void> updateUsuarioCreditos(String uuid, String creditos) async {
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
      throw Exception(response.body);
    }
  }

  Future<void> updateMe(Usuario usuario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _usuarios[_usuarios
          .indexWhere((element) => element.uuid == usuario.uuid)] = Usuario(
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
      throw Exception(response.body);
    }
  }

  Future<void> deleteUsuario(String uuid) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$uuid'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 204) {
      _usuarios.removeWhere((element) => element.uuid == uuid);
      notifyListeners();
    } else {
      throw Exception(response.body);
    }
  }
}