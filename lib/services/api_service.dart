// Guardé este archivo en: D:\06MASW-A1\en_mi_ciudad\lib\services\api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:en_mi_ciudad/models/event_model.dart';

/// Configuré este servicio para consumir el API REST (json_server) con los campos de mi db.json.
class ApiService {
  /// Cambié 'localhost' a '10.0.2.2' cuando usé el emulador Android.
  final String baseUrl = 'http://10.0.2.2:3000';

  /// (GET) Obtuve la lista de eventos: /events
  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));
    if (response.statusCode == 200) {
      // Decodifiqué usando bytes crudos + utf8.decode para manejar acentos.
      final decodedBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonList = jsonDecode(decodedBody);
      return jsonList.map((item) => Event.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener la lista de eventos');
    }
  }

  /// Retorné el siguiente ID secuencial como string.
  /// Analicé el mayor ID numérico y devolví max + 1.
  Future<String> getNextSequentialId() async {
    final events = await fetchEvents();
    int maxId = 0;
    for (final e in events) {
      final currentId = int.tryParse(e.id ?? '0') ?? 0;
      if (currentId > maxId) {
        maxId = currentId;
      }
    }
    return (maxId + 1).toString();
  }

  /// (POST) Creé un nuevo evento: /events
  Future<Event> createEvent(Event newEvent) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newEvent.toJson()),
    );

    print('POST /events status: ${response.statusCode}');
    print('POST /events response: ${response.body}');

    if (response.statusCode == 201) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonMap = jsonDecode(decodedBody);
      return Event.fromJson(jsonMap);
    } else {
      throw Exception('Error al crear el evento');
    }
  }

  /// (PUT) Actualicé un evento existente: /events/{id}
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
      final decodedBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonMap = jsonDecode(decodedBody);
      return Event.fromJson(jsonMap);
    } else {
      throw Exception('Error al actualizar el evento');
    }
  }

  /// (DELETE) Eliminé un evento: /events/{id}
  Future<void> deleteEvent(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/events/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el evento');
    }
  }
}
