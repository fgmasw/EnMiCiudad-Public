// Archivo: D:\06MASW-A1\en_mi_ciudad\lib\models\event_model.dart

/// Representa un evento con todos los campos que figuran en tu db.json.
/// 'id' es un String para soportar retornos como "19e4" o "abc123".
class Event {
  final String? id;
  final String title;
  final String category;
  final String city;
  final String type;     // "Presencial" u "Online"
  final String date;
  final String hour;
  final String location; // "Online" o un lugar físico
  final String price;
  final String description;

  Event({
    this.id,
    required this.title,
    required this.category,
    required this.city,
    required this.type,
    required this.date,
    required this.hour,
    required this.location,
    required this.price,
    required this.description,
  });

  /// Construye un Event a partir de un objeto JSON.
  /// 'id' se obtiene tal cual string, por si json_server retorna algo no decimal.
  factory Event.fromJson(Map<String, dynamic> json) {
    final dynamic rawId = json['id'];
    final String? stringId = rawId?.toString();

    return Event(
      id: stringId,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      city: json['city'] ?? '',
      type: json['type'] ?? '',
      date: json['date'] ?? '',
      hour: json['hour'] ?? '',
      location: json['location'] ?? '',
      price: json['price'] ?? '',
      description: json['description'] ?? '',
    );
  }

  /// Convierte este Event a un Map para serializar a JSON.
  /// Omitimos 'id' para que json_server lo genere o mantenga.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'city': city,
      'type': type,
      'date': date,
      'hour': hour,
      'location': location,
      'price': price,
      'description': description,
    };
  }
}
