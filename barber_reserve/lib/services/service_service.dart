import 'dart:async';
import '../models/service_model.dart';
import '../models/professional_model.dart';
import '../models/appointment_model.dart';

class ServiceService {
  Future<List<ServiceModel>> getServicos() async {
    await Future.delayed(const Duration(milliseconds: 900));

    
    return [
      ServiceModel(
        id: 1,
        titulo: "Cabelo",
        descricao: "Corte moderno e estiloso",
        preco: 30.0,
        duracaoMinutos: 30,
        profissionais: [
          Professional(id: 10, nome: "Marcos Albuquerque"),
          Professional(id: 11, nome: "Carlos Santos"),
        ],
      ),
      ServiceModel(
        id: 2,
        titulo: "Barba",
        descricao: "Corte moderno e estiloso",
        preco: 20.0,
        duracaoMinutos: 20,
        profissionais: [
          Professional(id: 12, nome: "José Antônio"),
        ],
      ),
    ];
  }

  Future<bool> enviarAgendamento(Appointment ag) async {
    await Future.delayed(const Duration(milliseconds: 800));

    print('Enviando agendamento: ${ag.toJson()}');
    return true;
  }
}
