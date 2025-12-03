import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_service.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = "access_token";

static Future<Map<String, dynamic>> register({
  required String fullName,
  required String email,
  required String password,
  required String phone,
}) async {
  final res = await ApiService.post(
    "usuario/register",
    {
      "full_name": fullName,
      "email": email,
      "password": password,
      "telefone": phone, 
    },
  );

  return res;
}


  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await ApiService.post(
      "usuario/login",
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


  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

 
  static Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  
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
  
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();

    if (token == null) {
      return {
        "statusCode": 401,
        "body": {"detail": "Usuário não autenticado"}
      };
    }

    return await ApiService.getUserProfile(token);
  }
}

 