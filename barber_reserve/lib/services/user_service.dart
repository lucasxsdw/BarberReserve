import 'package:barber_reserve/models/user_model.dart';
import 'package:barber_reserve/services/api_service.dart';
import 'package:barber_reserve/services/auth_service.dart';

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
  static Future<UserModel?> updateTipoPerfil(String tipoPerfil) async {
    final token = await AuthService.getToken();

    if (token == null) {
      print('UserService.updateTipoPerfil: token nulo (usuário não logado)');
      return null;
    }

    final res = await ApiService.patch(
      "usuario/me",
      {
        "tipo_perfil": tipoPerfil,
      },
      token: token,
    );

    if (res["statusCode"] == 200 && res["body"] is Map<String, dynamic>) {
      return UserModel.fromJson(res["body"] as Map<String, dynamic>);
    }

    print("UserService.updateTipoPerfil: erro ${res["statusCode"]} -> ${res["body"]}");
    return null;
  }
}
