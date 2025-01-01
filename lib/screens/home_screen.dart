// Archivo: D:\06MASW-A1\en_mi_ciudad\lib\screens\home_screen.dart

import 'package:flutter/material.dart';
import 'package:en_mi_ciudad/services/api_service.dart';
import 'package:en_mi_ciudad/models/event_model.dart';
// Descomenta la siguiente línea para usar tu EventCard:
import 'package:en_mi_ciudad/widgets/event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    // Al iniciar, cargamos la lista de eventos
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
              Navigator.pushNamed(context, '/form').then((value) {
                // Si en form_screen se guarda algo y retorna true,
                // refrescamos la lista
                if (value == true) {
                  setState(() {
                    _futureEvents = _apiService.fetchEvents();
                  });
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Event>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mostramos un indicador de carga mientras esperamos
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Si ocurrió un error en la petición
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Si la lista está vacía o sin datos
            return const Center(
              child: Text('No hay eventos disponibles.'),
            );
          } else {
            // Tenemos lista de eventos
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];

                // OPCIÓN A: Usar tu widget personalizado EventCard
                return EventCard(
                  event: event,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: event,
                    ).then((value) {
                      // Si en detail_screen se editó/eliminó algo y retorna true
                      if (value == true) {
                        setState(() {
                          _futureEvents = _apiService.fetchEvents();
                        });
                      }
                    });
                  },
                );

                // OPCIÓN B: Si prefieres ListTile, comenta lo anterior y descomenta esto:
                /*
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text('Fecha: ${event.date}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: event,
                    ).then((value) {
                      if (value == true) {
                        setState(() {
                          _futureEvents = _apiService.fetchEvents();
                        });
                      }
                    });
                  },
                );
                */
              },
            );
          }
        },
      ),
    );
  }
}
