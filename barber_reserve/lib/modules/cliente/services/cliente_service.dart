import 'package:barber_reserve/core/api/api_service.dart';
import 'package:barber_reserve/core/auth/auth_service.dart';
import 'package:barber_reserve/modules/usuario/models/user_model.dart';

class ClienteService {
  static Future<UserModel?> definirComoCliente() async {
    final token = await AuthService.getToken();

    final response = await ApiService.post(
      "cliente/definir",      // vira /api/cliente/definir/ na API
      {},                     // corpo vazio
      token: token,
    );

    if (response["statusCode"] == 200) {
      // a API devolve o Cliente, com um "usuario" dentro
      final usuarioJson = response["body"]["usuario"];
      return UserModel.fromJson(usuarioJson);
    }

    print("Erro definirComoCliente: ${response["body"]}");
    return null;
  }
}
