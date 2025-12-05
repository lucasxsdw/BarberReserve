import '../../servico/models/service_model.dart';
import '../../profissional/models/professional_model.dart';

class Appointment {
  final ServiceModel servico;
  final Professional profissional;
  final DateTime data;
  final String horaInicio;
  final String horaFim;

  Appointment({
    required this.servico,
    required this.profissional,
    required this.data,
    required this.horaInicio,
    required this.horaFim,
  });

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
