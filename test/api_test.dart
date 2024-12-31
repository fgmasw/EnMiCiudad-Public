import 'package:flutter_test/flutter_test.dart';
import 'package:en_mi_ciudad/services/api_service.dart';

void main() {
  group('ApiService Tests', () {
    // Test 1: Probar fetchEvents()
    test('fetchEvents should return a list of events', () async {
      final api = ApiService();

      // Llamar al método para obtener la lista
      final events = await api.fetchEvents();

      // Imprimir la cantidad de eventos en consola
      print('Se obtuvieron ${events.length} eventos del servidor json_server.');

      // Verificar que sea una lista no vacía (ajusta según tu escenario)
      expect(events.isNotEmpty, true, reason: 'La lista de eventos está vacía.');
    });

    // Test 2: Flujo de crear, actualizar y borrar un evento
    test('createEvent, updateEvent, deleteEvent flow', () async {
      final api = ApiService();

      // 1. Crear un nuevo evento
      final newEvent = Event(
        // id: no lo definimos, lo asignará json_server automáticamente
        title: 'Evento de Prueba Test',
        category: 'test',
        city: 'Ciudad de Ejemplo',
        type: 'Online',
        date: '2025-01-01',
        hour: '10:00',
        location: 'Online',
        price: 'R\$ 0',
        description: 'Este es un evento de prueba para el test unitario',
      );

      final created = await api.createEvent(newEvent);
      print('Evento creado con ID: ${created.id}');

      // Verificamos que se haya creado y asignado un ID
      expect(created.id, isNotNull, reason: 'El evento recién creado no tiene ID.');
      expect(created.title, equals('Evento de Prueba Test'));

      // 2. Actualizar el evento
      final updatedEvent = Event(
        id: created.id, // Usamos el ID generado
        title: 'Evento Actualizado en Test',
        category: created.category,
        city: created.city,
        type: created.type,
        date: created.date,
        hour: created.hour,
        location: created.location,
        price: created.price,
        description: created.description,
      );

      final updated = await api.updateEvent(updatedEvent);
      expect(updated.title, equals('Evento Actualizado en Test'),
          reason: 'No se ha actualizado correctamente el título.');

      // 3. Eliminar el evento
      await api.deleteEvent(updated.id!);
      print('Evento con ID ${updated.id} eliminado.');

      // Comprobar que ya no está en la lista
      final allEvents = await api.fetchEvents();
      final stillExists = allEvents.any((e) => e.id == updated.id);
      expect(stillExists, isFalse, reason: 'El evento no se eliminó de la lista.');
    });
  });
}
