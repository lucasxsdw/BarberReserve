import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:8000/api";

  // =========================
  // MÉTODOS GENÉRICOS
  // =========================

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

  static Future<Map<String, dynamic>> patch(
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

      final response = await http.patch(
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
      print("Erro em ApiService.patch($endpoint): $e");
      return {
        "statusCode": 500,
        "body": {"error": "Erro ao conectar com servidor"}
      };
    }
  }

  // =========================
  // AUTENTICAÇÃO / USUÁRIO
  // =========================

  Future<Map<String, dynamic>> login(String email, String password) async {
    return await ApiService.post(
      "usuario/login",
      {
        "email": email,
        "password": password,
      },
    );
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    return await ApiService.post(
      "usuario/register",
      {
        "full_name": name,
        "email": email,
        "password": password,
        "telefone": phone,
      },
    );
  }

  // >>> AQUI É A MUDANÇA PRINCIPAL <<<
  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    return await ApiService.get(
      "usuario/me",      // <-- ALTERADO (antes era "usuario/usuario-perfil")
      token: token,
    );
  }

  // =========================
  // PROFISSIONAL
  // =========================
  static Future<Map<String, dynamic>> getProfissionais(String token) async {
    return await ApiService.get(
      "profissional",
      token: token,
    );
  }

  // =========================
  // SERVIÇOS
  // =========================

  /// Criar serviço
  static Future<Map<String, dynamic>> createServico({
    required String token,
    required String nome,
    required String descricao,
    required String preco,
    required int duracaoMinutos,
    required List<int> profissionaisIds,
  }) async {
    return await ApiService.post(
      "servico/servicos", // backend usa esse caminho
      {
        "nome": nome,
        "descricao": descricao,
        "preco": preco,
        "duracao_minutos": duracaoMinutos,
        "profissionais": profissionaisIds,
      },
      token: token,
    );
  }

  /// Listar serviços
  static Future<Map<String, dynamic>> getServicos(String token) async {
    return await ApiService.get(
      "servico/servicos",
      token: token,
    );
  }

  /// Atualizar serviço (PATCH)
  static Future<Map<String, dynamic>> updateServico({
    required String token,
    required int id,
    required Map<String, dynamic> data,
  }) async {
    return await ApiService.patch(
      "servico/servicos/$id",
      data,
      token: token,
    );
  }
}
