class ServiceModel {
  final int id;
  final String title;
  final String description;
  final int durationMinutes;
  final double price;

  ServiceModel({required this.id, required this.title, required this.description, required this.durationMinutes, required this.price});

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        durationMinutes: json['durationMinutes'] as int,
        price: (json['price'] as num).toDouble(),
      );
}
