class AppointmentModel {
  final int id;
  final String serviceTitle;
  final DateTime dateTime;
  final double price;

  AppointmentModel({required this.id, required this.serviceTitle, required this.dateTime, required this.price});

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
        id: json['id'] as int,
        serviceTitle: json['serviceTitle'] as String,
        dateTime: DateTime.parse(json['dateTime'] as String),
        price: (json['price'] as num).toDouble(),
      );
}
