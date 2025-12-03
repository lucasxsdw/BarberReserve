import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/appointment_model.dart';
import '../../../core/auth/auth_service.dart';
import '../../profissional/services/professional_service.dart';

class AppointmentService {
  static const String _baseUrl = 'http://localhost:8000/api/agendamento/';

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
}
