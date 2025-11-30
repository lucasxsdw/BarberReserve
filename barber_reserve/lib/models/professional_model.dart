class Professional {
  final int id;
  final String nome;

  Professional({
    required this.id,
    required this.nome,
  });

  factory Professional.fromJson(Map<String, dynamic> json) {
    return Professional(
      id: json['id'] as int,
      nome: json['nome'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
      };

  @override
  String toString() => nome;
}
