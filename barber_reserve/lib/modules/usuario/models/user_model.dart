class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String tipoPerfil;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.tipoPerfil,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['first_name'] as String? ?? '',
      email: json['email'] as String,
      phone: json['telefone'] as String?,
      tipoPerfil: json['tipo_perfil'] as String? ?? '',
    );
  }
}
