import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:8000/api";

  // Método POST genérico
  static Future<Map<String, dynamic>> post(
  String endpoint,
  Map<String, dynamic> data, {
  String? token,
}) async {
  final uri = Uri.parse("$baseUrl/$endpoint/");

  try {
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = {"raw": response.body};
    }

    return {
      "statusCode": response.statusCode,
      "body": body,
    };
  } catch (e) {
    print("Erro em ApiService.post($endpoint): $e");
    return {
      "statusCode": 500,
      "body": {"error": "Erro ao conectar com servidor"}
    };
  }
}

  // Método GET genérico
  static Future<Map<String, dynamic>> get(
  String endpoint, {
  String? token,
}) async {
  final uri = Uri.parse("$baseUrl/$endpoint/");

  try {
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    final response = await http.get(
      uri,
      headers: headers,
    );

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = {"raw": response.body};
    }

    return {
      "statusCode": response.statusCode,
      "body": body,
    };
  } catch (e) {
    print("Erro em ApiService.get($endpoint): $e");
    return {
      "statusCode": 500,
      "body": {"error": "Erro ao conectar com servidor"}
    };
  }
}

  // LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    return await ApiService.post(
      "login",
      {
        "email": email,
        "password": password,
      },
    );
  }

  // CADASTRO
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    return await ApiService.post(
      "register",
      {
        "full_name": name,
        "email": email,
        "password": password,
        "telefone": phone, // 👈 manda o telefone pro backend
      },
    );
  }


  // PERFIL DO USUÁRIO LOGADO
  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    return await ApiService.get(
      "usuario-perfil",
      token: token,
    );
  }
}
