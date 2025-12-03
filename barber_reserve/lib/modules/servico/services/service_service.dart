import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barber_reserve/modules/servico/models/service_model.dart';
import 'package:barber_reserve/core/auth/auth_service.dart';
import 'package:barber_reserve/modules/agendamento/models/appointment_model.dart';
import '../../profissional/services/professional_service.dart'; // aproveita o ApiException

class ServiceService {
  // Endpoint do Django: /api/servico/servicos/
  static const String _baseUrl = 'http://localhost:8000/api/servico/';

  // Criar serviço
  static Future<ServiceModel> createService({
    required String nome,
    required String descricao,
    required String preco,
    required int duracaoMinutos,
    required List<int> profissionaisIds,
  }) async {
    final headers = await AuthService.authHeaders();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode({
        'nome': nome,
        'descricao': descricao,
        'preco': preco,
        'duracao_minutos': duracaoMinutos,
        'profissionais': profissionaisIds,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return ServiceModel.fromJson(data);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // Listar serviços do salão do usuário logado
  static Future<List<ServiceModel>> getServicos() async {
    final headers = await AuthService.authHeaders();

    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ServiceModel.fromJson(e)).toList();
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // Atualizar serviço (PATCH – atualização parcial)
  static Future<ServiceModel> updateService({
    required int id,
    String? nome,
    String? descricao,
    String? preco,
    int? duracaoMinutos,
    List<int>? profissionaisIds,
  }) async {
    final headers = await AuthService.authHeaders();

    final Map<String, dynamic> body = {};
    if (nome != null) body['nome'] = nome;
    if (descricao != null) body['descricao'] = descricao;
    if (preco != null) body['preco'] = preco;
    if (duracaoMinutos != null) body['duracao_minutos'] = duracaoMinutos;
    if (profissionaisIds != null) body['profissionais'] = profissionaisIds;

    final response = await http.patch(
      Uri.parse('$_baseUrl$id/'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ServiceModel.fromJson(data);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // Deletar serviço
  static Future<void> deleteService(int id) async {
    final headers = await AuthService.authHeaders();

    final response = await http.delete(
      Uri.parse('$_baseUrl$id/'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw ApiException(response.statusCode, response.body);
    }
  }

}
