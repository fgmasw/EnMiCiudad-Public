import 'dart:convert';
import 'package:http/http.dart' as http;

/// Representa un evento con todos los campos que figuran en tu db.json.
/// En este caso, 'id' será un String para soportar retornos como "19e4".
class Event {
  final String? id; // AHORA ES STRING
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
    this.id, // String
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
  /// 'id' se obtiene tal cual string, en caso de que json_server retorne "19e4", "abc123", etc.
  factory Event.fromJson(Map<String, dynamic> json) {
    // Aseguramos tomar 'id' como string
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
  /// Omitimos 'id' para que json_server lo genere o mantenga como sea.
  Map<String, dynamic> toJson() {
    return {
      // 'id': id, // No lo incluimos
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

class ApiService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((item) => Event.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener la lista de eventos');
    }
  }

  Future<Event> createEvent(Event newEvent) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newEvent.toJson()),
    );

    print('POST /events status: ${response.statusCode}');
    print('POST /events response: ${response.body}');

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return Event.fromJson(jsonMap);
    } else {
      throw Exception('Error al crear el evento');
    }
  }

  Future<Event> updateEvent(Event updatedEvent) async {
    if (updatedEvent.id == null) {
      throw Exception('No se puede actualizar un evento sin ID');
    }
    final response = await http.put(
      Uri.parse('$baseUrl/events/${updatedEvent.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedEvent.toJson()),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return Event.fromJson(jsonMap);
    } else {
      throw Exception('Error al actualizar el evento');
    }
  }

  Future<void> deleteEvent(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/events/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el evento');
    }
  }
}
