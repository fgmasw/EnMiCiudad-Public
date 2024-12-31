// Archivo: D:\06MASW-A1\en_mi_ciudad\lib\screens\home_screen.dart

import 'package:flutter/material.dart';
import 'package:en_mi_ciudad/services/api_service.dart';
import 'package:en_mi_ciudad/models/event_model.dart';
// (Opcional) Si tienes un widget "EventCard" en lib/widgets/event_card.dart:
// import 'package:en_mi_ciudad/widgets/event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = _apiService.fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EnMiCiudad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Crear nuevo evento',
            onPressed: () {
              // Navegar a la pantalla de formulario
              Navigator.pushNamed(context, '/form');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Event>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras esperamos la respuesta
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Si hubo error en la petición
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Lista vacía o sin datos
            return const Center(
              child: Text('No hay eventos disponibles.'),
            );
          } else {
            // Tenemos una lista de eventos
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];

                // Opcional: Usa un Widget personalizado (EventCard).
                // return EventCard(event: event);

                // Ejemplo básico con ListTile:
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text('Fecha: ${event.date}'),
                  onTap: () {
                    // Navegar a detail_screen, pasando el evento o su ID
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: event, // Pasamos el objeto entero
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
