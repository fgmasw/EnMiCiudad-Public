// Archivo: D:\06MASW-A1\en_mi_ciudad\lib\services\api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:en_mi_ciudad/models/event_model.dart';
// Importamos la clase Event desde event_model.dart

class ApiService {
  // Cambia 'localhost' a '10.0.2.2' si usas emulador Android.
  final String baseUrl = 'http://localhost:3000';

  /// (GET) Obtiene la lista de eventos: /events
  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((item) => Event.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener la lista de eventos');
    }
  }

  /// (POST) Crea un nuevo evento: /events
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

  /// (PUT) Actualiza un evento existente: /events/{id}
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

  /// (DELETE) Elimina un evento: /events/{id}
  Future<void> deleteEvent(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/events/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el evento');
    }
  }
}
