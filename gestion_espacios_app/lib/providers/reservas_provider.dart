import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/models/reserva.dart';
import 'package:http/http.dart' as http;

class ReservasProvider with ChangeNotifier {
  final String? _token;

  List<Reserva> _reservas = [];
  List<Reserva> _reservasByUser = [];
  List<Reserva> _reservasBySpace = [];
  List<Reserva> _reservasByStatus = [];
  List<Reserva> _reservasByTime = [];

  List<Reserva> get reservas => _reservas;
  List<Reserva> get reservasByUser => _reservasByUser;
  List<Reserva> get reservasBySpace => _reservasBySpace;
  List<Reserva> get reservasByStatus => _reservasByStatus;
  List<Reserva> get reservasByTime => _reservasByTime;

  ReservasProvider(this._token) {
    fetchReservas();
  }

  Future<void> fetchReservas() async {
    final response = await http.get(
        Uri.parse('http://magarcia.asuscomm.com:25546/bookings'),
        headers: {'Authorization': 'Bearer $_token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['data'] as List<dynamic>;
      _reservas = results
          .map((json) => Reserva(
                uuid: json['uuid'],
                userId: json['userId'],
                spaceId: json['spaceId'],
                startTime: json['startTime'],
                endTime: json['endTime'],
                phone: json['phone'],
                status: json['status'],
              ))
          .toList();
    }
  }

  Future<Reserva?> fetchReservaByUuid(String uuid) async {
    final response = await http.get(
      Uri.parse('http://magarcia.asuscomm.com:25546/bookings/$uuid'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Reserva(
        uuid: data['uuid'],
        userId: data['userId'],
        spaceId: data['spaceId'],
        startTime: data['startTime'],
        endTime: data['endTime'],
        phone: data['phone'],
        status: data['status'],
      );
    } else {
      return null;
    }
  }

  Future<void> fetchReservasByUser(String userUuid) async {
    final response = await http.get(
      Uri.parse('http://magarcia.asuscomm.com:25546/bookings/user/$userUuid'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['data'] as List<dynamic>;
      _reservasByUser = results
          .map((json) => Reserva(
                uuid: json['uuid'],
                userId: json['userId'],
                spaceId: json['spaceId'],
                startTime: json['startTime'],
                endTime: json['endTime'],
                phone: json['phone'],
                status: json['status'],
              ))
          .toList();
    }
  }

  Future<void> fetchReservasBySpace(String spaceId) async {
    final response = await http.get(
      Uri.parse('http://magarcia.asuscomm.com:25546/bookings/space/$spaceId'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['data'] as List<dynamic>;
      _reservasBySpace = results
          .map((json) => Reserva(
                uuid: json['uuid'],
                userId: json['userId'],
                spaceId: json['spaceId'],
                startTime: json['startTime'],
                endTime: json['endTime'],
                phone: json['phone'],
                status: json['status'],
              ))
          .toList();
    }
  }

  Future<void> fetchReservasByStatus(String status) async {
    final response = await http.get(
      Uri.parse('http://magarcia.asuscomm.com:25546/bookings/status/$status'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['data'] as List<dynamic>;
      _reservasByStatus = results
          .map((json) => Reserva(
                uuid: json['uuid'],
                userId: json['userId'],
                spaceId: json['spaceId'],
                startTime: json['startTime'],
                endTime: json['endTime'],
                phone: json['phone'],
                status: json['status'],
              ))
          .toList();
    }
  }

  Future<void> fetchReservasByTime(
      String time, String uuidSpace) async {
    final response = await http.get(
      Uri.parse(
          'http://magarcia.asuscomm.com:25546/bookings/time/$uuidSpace/$time'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['data'] as List<dynamic>;
      _reservasByTime = results
          .map((json) => Reserva(
                uuid: json['uuid'],
                userId: json['userId'],
                spaceId: json['spaceId'],
                startTime: json['startTime'],
                endTime: json['endTime'],
                phone: json['phone'],
                status: json['status'],
              ))
          .toList();
    }
  }

  Future<void> addReserva(Reserva reserva) async {
    final response = await http.post(
        Uri.parse('http://magarcia.asuscomm.com:25546/bookings'),
        headers: {'Authorization': 'Bearer $_token'},
        body: jsonEncode(reserva));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _reservas.add(Reserva(
        uuid: data['uuid'],
        userId: data['userId'],
        spaceId: data['spaceId'],
        startTime: data['startTime'],
        endTime: data['endTime'],
        phone: data['phone'],
        status: data['status'],
      ));
      notifyListeners();
    }
  }

  Future<void> updateReserva(Reserva reserva) async {
    final response = await http.put(
        Uri.parse(
            'http://magarcia.asuscomm.com:25546/bookings/${reserva.uuid}'),
        headers: {'Authorization': 'Bearer $_token'},
        body: jsonEncode(reserva));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _reservas[_reservas
          .indexWhere((element) => element.uuid == reserva.uuid)] = Reserva(
        uuid: data['uuid'],
        userId: data['userId'],
        spaceId: data['spaceId'],
        startTime: data['startTime'],
        endTime: data['endTime'],
        phone: data['phone'],
        status: data['status'],
      );
      notifyListeners();
    }
  }

  Future<void> deleteReserva(String uuid) async {
    final response = await http.delete(
        Uri.parse('http://magarcia.asuscomm.com:25546/bookings/$uuid'),
        headers: {'Authorization': 'Bearer $_token'});

    if (response.statusCode == 200) {
      _reservas.removeWhere((element) => element.uuid == uuid);
      notifyListeners();
    }
  }
}