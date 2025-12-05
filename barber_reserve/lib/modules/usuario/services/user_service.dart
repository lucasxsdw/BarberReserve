import 'package:barber_reserve/modules/usuario/models/user_model.dart';
import 'package:barber_reserve/core/api/api_service.dart';
import 'package:barber_reserve/core/auth/auth_service.dart';

class UserService {
  /// GET /api/usuario/me/  -> dados do usuário logado
  static Future<UserModel?> getMe() async {
    final token = await AuthService.getToken();

    if (token == null) {
      print('UserService.getMe: token nulo (usuário não logado)');
      return null;
    }

    final res = await ApiService.get(
      "usuario/me",
      token: token,
    );

    if (res["statusCode"] == 200 && res["body"] is Map<String, dynamic>) {
      return UserModel.fromJson(res["body"] as Map<String, dynamic>);
    }

    print("UserService.getMe: erro ${res["statusCode"]} -> ${res["body"]}");
    return null;
  }

  /// PATCH /api/usuario/me/  -> atualiza tipo_perfil (CLIENTE ou SALAO)
  static Future<UserModel?> updateTipoPerfil(String role) async {
    final token = await AuthService.getToken();

    final response = await ApiService.post(
      "usuario/tipo-perfil",        
      {
        "tipo_perfil": role,        
      },
      token: token,
    );

    if (response["statusCode"] == 200) {
      return UserModel.fromJson(response["body"]);
    }

    print("Erro updateTipoPerfil: ${response["body"]}");
    return null;
  }
}
