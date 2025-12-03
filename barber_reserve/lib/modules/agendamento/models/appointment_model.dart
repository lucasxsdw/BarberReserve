import '../../servico/models/service_model.dart';
import '../../profissional/models/professional_model.dart';

class Appointment {
  final ServiceModel servico;
  final Professional profissional;
  final DateTime data;
  final String horario;

  Appointment({
    required this.servico,
    required this.profissional,
    required this.data,
    required this.horario,
  });

  Map<String, dynamic> toJson() {
    return {
      'servico_id': servico.id,
      'profissional_id': profissional.id,
      'data': data.toIso8601String(),
      'horario': horario,
    };
  }
}
