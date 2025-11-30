import 'professional_model.dart';

class ServiceModel {
  final int id;
  final String titulo;
  final String descricao;
  final double preco;
  final int duracaoMinutos;
  final List<Professional> profissionais;

  ServiceModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.preco,
    required this.duracaoMinutos,
    required this.profissionais,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String,
      preco: (json['preco'] as num).toDouble(),
      duracaoMinutos: json['duracao'] as int,
      profissionais: (json['profissionais'] as List<dynamic>)
          .map((p) => Professional.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'descricao': descricao,
        'preco': preco,
        'duracao': duracaoMinutos,
        'profissionais': profissionais.map((p) => p.toJson()).toList(),
      };
}
