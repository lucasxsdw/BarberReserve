import '../../servico/models/service_model.dart';
import '../../profissional/models/professional_model.dart';

class Appointment {
  final int? id;
  final ServiceModel servico;
  final Professional profissional;
  final DateTime data;
  final String horaInicio;
  final String horaFim;

  Appointment({
    this.id,
    required this.servico,
    required this.profissional,
    required this.data,
    required this.horaInicio,
    required this.horaFim,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    final dynamic servicoJson = json['servico'];
    final dynamic profJson = json['profissional'];

    // ---- tratar SERVIÇO (pode vir objeto ou ID) ----
    late final ServiceModel servicoModel;

    if (servicoJson is Map<String, dynamic>) {
      // formato completo: { id, nome, preco, ... }
      servicoModel = ServiceModel.fromJson(servicoJson);
    } else if (servicoJson is int) {
      // só o ID -> cria um "placeholder" mínimo
      servicoModel = ServiceModel(
        id: servicoJson,
        titulo: 'Serviço #$servicoJson',
        descricao: null,
        preco: 0.0,
        duracaoMinutos: 0,
        profissionais: const [],
      );
    } else {
      throw Exception('Formato inesperado de servico: $servicoJson');
    }

    // ---- tratar PROFISSIONAL (seu Professional já aceita int/map/string) ----
    final profissionalModel = Professional.fromJson(profJson);

    return Appointment(
      id: json['id'] as int?,
      servico: servicoModel,
      profissional: profissionalModel,
      data: DateTime.parse(json['data_agendada']),
      horaInicio: json['hora_inicio'] as String,
      horaFim: json['hora_fim'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profissional': profissional.id,
      'servico': servico.id,
      'data_agendada': data.toIso8601String().split("T").first,
      'hora_inicio': horaInicio,
      'hora_fim': horaFim,
    };
  }
}
