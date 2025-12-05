import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barber_reserve/modules/profissional/models/newprofessional_model.dart';
import 'package:barber_reserve/core/auth/auth_service.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ProfessionalService {
  static const String _baseUrl = 'http://localhost:8000/api/profissional/';

  static Future<ProfessionalModel> createProfessional(
      ProfessionalModel professional) async {
    final headers = await AuthService.authHeaders();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode(professional.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return ProfessionalModel.fromJson(data);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  static Future<List<ProfessionalModel>> getProfessionals() async {
    final headers = await AuthService.authHeaders();

    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProfessionalModel.fromJson(e)).toList();
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  static Future<ProfessionalModel> updateProfessional(
      ProfessionalModel professional) async {
    if (professional.id == null) {
      throw ArgumentError('ProfessionalModel.id não pode ser null para update');
    }

    final headers = await AuthService.authHeaders();

    final response = await http.put(
      Uri.parse('$_baseUrl${professional.id}/'),
      headers: headers,
      body: jsonEncode(professional.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProfessionalModel.fromJson(data);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  static Future<void> deleteProfessional(int id) async {
    final headers = await AuthService.authHeaders();

    final response = await http.delete(
      Uri.parse('$_baseUrl$id/'),
      headers: headers,
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw ApiException(response.statusCode, response.body);
    }
  }
}
