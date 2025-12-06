import 'package:barber_reserve/core/api/api_service.dart';
import 'package:barber_reserve/core/auth/auth_service.dart';

class SalaoService {
  /// Criar ou atualizar o salão do usuário logado
  static Future<Map<String, dynamic>> criarOuAtualizarSalao({
    required String nome,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      return {
        "statusCode": 401,
        "body": {"detail": "Usuário não autenticado"}
      };
    }

    return await ApiService.post(
      "salao/",
      {"nome": nome},
      token: token,
    );
  }

  /// Buscar o salão do usuário logado
  static Future<Map<String, dynamic>> getSalaoUsuario() async {
    final token = await AuthService.getToken();
    if (token == null) {
      return {
        "statusCode": 401,
        "body": {"detail": "Usuário não autenticado"}
      };
    }

    return await ApiService.get(
      "salao",
      token: token,
    );
  }

 
  static Future<Map<String, dynamic>> getTodosSalao() async {
    final token = await AuthService.getToken();
    return await ApiService.get(
      "salao",
      token: token,
    );
  }
}
