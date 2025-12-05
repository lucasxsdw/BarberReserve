// lib/modules/agendamento/services/appointment_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/appointment_model.dart';
import '../../../core/auth/auth_service.dart';

class ApiException implements Exception {
  final int statusCode;
  final String body;

  ApiException(this.statusCode, this.body);

  @override
  String toString() => 'ApiException($statusCode): $body';
}

class AppointmentService {
  static const String _baseUrl = 'http://localhost:8000/api/agendamento/';

  // CREATE
  static Future<bool> enviarAgendamento(Appointment ag) async {
    final headers = await AuthService.authHeaders();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode(ag.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // READ (listar agendamentos do usuário logado)
  static Future<List<Appointment>> getAppointments() async {
    final headers = await AuthService.authHeaders();

    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data
            .map((item) => Appointment.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Resposta inesperada da API de agendamento');
      }
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // UPDATE (PATCH)
  static Future<void> updateAppointment(
      int id, Map<String, dynamic> data) async {
    final headers = await AuthService.authHeaders();

    final response = await http.patch(
      Uri.parse('$_baseUrl$id/'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // DELETE
  static Future<void> deleteAppointment(int id) async {
    final headers = await AuthService.authHeaders();

    final response = await http.delete(
      Uri.parse('$_baseUrl$id/'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw ApiException(response.statusCode, response.body);
    }
  }
}
