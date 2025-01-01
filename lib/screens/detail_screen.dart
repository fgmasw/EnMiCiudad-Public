// Archivo: D:\06MASW-A1\en_mi_ciudad\lib\screens\detail_screen.dart

import 'package:flutter/material.dart';
import 'package:en_mi_ciudad/models/event_model.dart';
import 'package:en_mi_ciudad/services/api_service.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Recibimos el objeto Event
    final event = ModalRoute.of(context)!.settings.arguments as Event;

    // Creamos una instancia de ApiService para eliminar si hace falta
    final apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del evento
            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Categoría y Fecha
            Row(
              children: [
                Text(
                  'Categoría: ${event.category}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(
                  'Fecha: ${event.date}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Ciudad y Hora
            Row(
              children: [
                Text(
                  'Ciudad: ${event.city}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(
                  'Hora: ${event.hour}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Tipo, Precio
            Text(
              'Tipo: ${event.type}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Precio: ${event.price}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            // Ubicación
            Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.location,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Descripción
            Text(
              'Descripción:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              event.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            // Botones de acción (Editar, Eliminar, Volver)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botón Editar
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                  onPressed: () async {
                    // Navegar a FormScreen para editar, pasando el objeto Event
                    final result = await Navigator.pushNamed(
                      context,
                      '/form',
                      arguments: event,
                    );
                    // Si regresamos con true, refrescar al salir de detail
                    if (context.mounted && result == true) {
                      Navigator.pop(context, true);
                    }
                  },
                ),
                const SizedBox(width: 8),
                // Botón Eliminar
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Eliminar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    try {
                      // Confirmación rápida (opcional)
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirmar eliminación'),
                          content: Text(
                            '¿Deseas eliminar "${event.title}" de manera permanente?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        // Llamamos a deleteEvent con el ID
                        if (event.id != null) {
                          await apiService.deleteEvent(event.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Evento eliminado.')),
                          );
                          Navigator.pop(context, true);
                        } else {
                          // Sin ID no se puede eliminar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No se puede eliminar: ID nulo.'),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al eliminar: $e')),
                      );
                    }
                  },
                ),
                const SizedBox(width: 8),
                // Botón Volver
                ElevatedButton(
                  child: const Text('Volver'),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
