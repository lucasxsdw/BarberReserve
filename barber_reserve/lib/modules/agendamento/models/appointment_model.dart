import '../../servico/models/service_model.dart';
import '../../profissional/models/professional_model.dart';

class Appointment {
  final int? id;                     // agora é OPCIONAL
  final ServiceModel servico;
  final Professional profissional;
  final DateTime data;
  final String horaInicio;
  final String horaFim;

  Appointment({
    this.id,                         // pode ser null
    required this.servico,
    required this.profissional,
    required this.data,
    required this.horaInicio,
    required this.horaFim,
  });

  /// Vindo da API (para LISTAR no admin)
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as int?,
      servico: ServiceModel.fromJson(json['servico']),
      profissional: Professional.fromJson(json['profissional']),
      data: DateTime.parse(json['data_agendada']),
      horaInicio: json['hora_inicio'] as String,
      horaFim: json['hora_fim'] as String,
    );
  }

  /// Usado para ENVIAR pra API (create/update)
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
