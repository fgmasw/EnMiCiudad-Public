// Archivo: D:\06MASW-A1\en_mi_ciudad\lib\screens\detail_screen.dart

import 'package:flutter/material.dart';
import 'package:en_mi_ciudad/models/event_model.dart';
import 'package:en_mi_ciudad/services/api_service.dart';

// Importamos el helper de SharedPreferences para leer isDarkMode():
import 'package:en_mi_ciudad/utils/shared_prefs_helper.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Event event;
  final apiService = ApiService();

  // Variable para saber si estamos en modo oscuro
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // Cargar el modo oscuro desde SharedPreferences
    _loadDarkMode();
  }

  /// Lee la preferencia darkMode de SharedPreferences
  Future<void> _loadDarkMode() async {
    final bool dark = await SharedPrefsHelper.isDarkMode();
    setState(() {
      _isDarkMode = dark;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recibimos el objeto Event solo cuando tenemos acceso al context
    event = ModalRoute.of(context)!.settings.arguments as Event;
  }

  @override
  Widget build(BuildContext context) {
    // Definimos colores según _isDarkMode
    final backgroundColor = _isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black;
    final appBarColor = _isDarkMode ? Colors.grey[850] : Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          event.title,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: textColor),
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
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),

            // Categoría y Fecha
            Row(
              children: [
                Text(
                  'Categoría: ${event.category}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
                ),
                const Spacer(),
                Text(
                  'Fecha: ${event.date}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Ciudad y Hora
            Row(
              children: [
                Text(
                  'Ciudad: ${event.city}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
                ),
                const Spacer(),
                Text(
                  'Hora: ${event.hour}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Tipo, Precio
            Text(
              'Tipo: ${event.type}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Precio: ${event.price}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),

            // Ubicación
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: _isDarkMode ? Colors.amberAccent : Colors.redAccent,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.location,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: textColor,
                    ),
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
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              event.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: textColor,
              ),
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
                    // Confirmación
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
                      try {
                        if (event.id != null) {
                          await apiService.deleteEvent(event.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Evento eliminado.')),
                          );
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No se puede eliminar: ID nulo.'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al eliminar: $e')),
                        );
                      }
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
