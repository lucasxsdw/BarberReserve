import '../../profissional/models/professional_model.dart';

class ServiceModel {
  final int id;
  final String titulo;
  final String? descricao;
  final double preco;
  final int duracaoMinutos;
  final List<Professional> profissionais;

  ServiceModel({
    required this.id,
    required this.titulo,
    this.descricao,
    required this.preco,
    required this.duracaoMinutos,
    required this.profissionais,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    // preco pode vir como "32.00" (String) ou 32.0 (num)
    final dynamic precoJson = json['preco'];
    double preco;
    if (precoJson is num) {
      preco = precoJson.toDouble();
    } else if (precoJson is String) {
      preco = double.tryParse(precoJson.replaceAll(',', '.')) ?? 0.0;
    } else {
      preco = 0.0;
    }

    return ServiceModel(
      id: json['id'] as int,

      // backend manda "nome"
      titulo: (json['nome'] ?? json['titulo'] ?? '').toString(),

      // pode ser null
      descricao: json['descricao'] as String?,

      preco: preco,

      // backend manda "duracao_minutos"
      duracaoMinutos: json['duracao_minutos'] as int? ??
          json['duracao'] as int? ??
          0,

      // profissionais_detalhes: lista de strings ("Sancho (Casa)")
      // ou lista de maps – ambos aceitos pelo Professional.fromJson(dynamic)
      profissionais:
          (json['profissionais_detalhes'] as List<dynamic>? ?? [])
              .map((p) => Professional.fromJson(p))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': titulo,
        'descricao': descricao,
        'preco': preco,
        'duracao_minutos': duracaoMinutos,
        // para enviar ao backend usamos só os IDs
        'profissionais': profissionais
            .where((p) => p.id != null)
            .map((p) => p.id)
            .toList(),
      };
}
