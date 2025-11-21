import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:8000/api/";

  // Método POST genérico
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse("$baseUrl$endpoint/");

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      return {
        "statusCode": response.statusCode,
        "body": jsonDecode(response.body),
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "body": {"error": "Erro ao conectar com servidor"}
      };
    }
  }

  // Método GET genérico (caso precise)
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final uri = Uri.parse("$baseUrl$endpoint/");

    try {
      final response = await http.get(
        uri,
        headers: {"Content-Type": "application/json"},
      );

      return {
        "statusCode": response.statusCode,
        "body": jsonDecode(response.body),
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "body": {"error": "Erro ao conectar com servidor"}
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
  return await ApiService.post("login", {
    "email": email,
    "password": password,
  });
}

Future<Map<String, dynamic>> register(String name, String email, String password, String phone) async {
  return await ApiService.post("register", {
    "full_name": name,
    "email": email,
    "password": password,
  });
}

}
