import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = "access_token";

  // ================================
  // REGISTER
  // ================================
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final res = await ApiService.post(
      "register",
      {
        "full_name": fullName,
        "email": email,
        "password": password,
      },
    );

    return res;
  }

  // ================================
  // LOGIN
  // ================================
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await ApiService.post(
      "login",
      {
        "email": email,
        "password": password,
      },
    );

    // salvando token JWT
    if (res["statusCode"] == 200) {
      final body = res["body"];

      if (body is Map && body["access"] != null) {
        await _storage.write(key: _tokenKey, value: body["access"]);
      }
    }

    return res;
  }

  // ================================
  // GET TOKEN
  // ================================
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // ================================
  // LOGOUT
  // ================================
  static Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  // ================================
  // AUTH HEADERS
  // ================================
  static Future<Map<String, String>> authHeaders() async {
    final token = await getToken();

    if (token == null) {
      return {"Content-Type": "application/json"};
    }

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }
}
