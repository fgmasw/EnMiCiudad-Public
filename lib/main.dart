import 'package:flutter/material.dart';

// Importa aquí tus pantallas reales (asegúrate de crearlas en lib/screens/).
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
      // Indica que la primera ruta al arrancar es '/'
      initialRoute: '/',
      routes: {
        // Rutas definidas para navegar a cada pantalla:
        '/': (context) => const HomeScreen(),
        '/detail': (context) => const DetailScreen(),
        '/form': (context) => const FormScreen(),
      },
      // Si lo deseas, puedes omitir "home:" pues initialRoute: '/' ya define la pantalla inicial
      // home: const PlaceholderHome(),
    );
  }
}

/// Si aún no tienes HomeScreen lista, podrías usar una pantalla placeholder.
/// Luego la sustituyes por HomeScreen cuando la crees de verdad.
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
