import 'package:flutter/material.dart';

// Importé aquí mis pantallas reales (y las creé en lib/screens/).
import 'package:en_mi_ciudad/screens/home_screen.dart';
import 'package:en_mi_ciudad/screens/detail_screen.dart';
import 'package:en_mi_ciudad/screens/form_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnMiCiudad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Definí la primera ruta al arrancar como '/'
      initialRoute: '/',
      routes: {
        // Definí estas rutas para navegar a cada pantalla
        '/': (context) => const HomeScreen(),
        '/detail': (context) => const DetailScreen(),
        '/form': (context) => const FormScreen(),
      },
      // Comenté que podía omitir "home:" porque initialRoute: '/' ya definía la pantalla inicial
      // home: const PlaceholderHome(),
    );
  }
}

/// Comenté que si no tenía lista la HomeScreen, podía usar una pantalla placeholder.
/// Luego la reemplacé por HomeScreen cuando la tuve creada de verdad.
/*
class PlaceholderHome extends StatelessWidget {
  const PlaceholderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EnMiCiudad'),
      ),
      body: const Center(
        child: Text(
          '¡Pantalla de inicio provisional!\nCrea tus pantallas y rutas.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
*/
