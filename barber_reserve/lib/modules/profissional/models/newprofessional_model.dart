class ProfessionalModel {
  final int? id;
  final String name; // mapeia para "nome" no backend

  ProfessionalModel({
    this.id,
    required this.name,
  });

  factory ProfessionalModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalModel(
      id: json['id'],
      name: json['nome'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': name, // é isso que o Django espera
    };
  }
}
