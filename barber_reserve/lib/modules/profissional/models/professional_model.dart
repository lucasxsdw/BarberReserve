class Professional {
  final int? id;
  final String nome;

  Professional({
    this.id,
    required this.nome,
  });

  /// Aceita vários formatos:
  /// - {"id": 1, "nome": "Sancho"}
  /// - "Sancho (Casa)"
  /// - 1
  factory Professional.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return Professional(
        id: json['id'] as int?,
        nome: (json['nome'] ?? json['name'] ?? '').toString(),
      );
    } else if (json is String) {
      return Professional(id: null, nome: json);
    } else if (json is int) {
      return Professional(id: json, nome: '');
    } else {
      return Professional(id: null, nome: json.toString());
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
    };
  }
}
