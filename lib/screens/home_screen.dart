// Guardé este archivo en: D:\06MASW-A1\en_mi_ciudad\lib\screens\home_screen.dart

import 'package:flutter/material.dart';
import 'package:en_mi_ciudad/services/api_service.dart';
import 'package:en_mi_ciudad/models/event_model.dart';
import 'package:en_mi_ciudad/widgets/event_card.dart';
import 'package:en_mi_ciudad/utils/shared_prefs_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  // Guardé la lista completa de eventos descargados
  List<Event> _allEvents = [];
  // Guardé la lista filtrada
  List<Event> _filteredEvents = [];

  // Definí la variable de modo oscuro
  bool _isDarkMode = false;

  // Definí el filtro de ciudades
  final List<String> _cityFilterOptions = [
    'Todas',
    'Sao Paulo',
    'Rio de Janeiro',
  ];
  String _selectedCityFilter = 'Todas'; // Lo puse por defecto

  @override
  void initState() {
    super.initState();

    _loadDarkMode();
    _initData(); // Cargué cityFilter de SharedPrefs y obtuve lista de eventos
  }

  /// Cargué el modo oscuro
  Future<void> _loadDarkMode() async {
    final bool dark = await SharedPrefsHelper.isDarkMode();
    setState(() {
      _isDarkMode = dark;
    });
  }

  /// Cargué la última ciudad guardada y obtuve la lista de eventos
  Future<void> _initData() async {
    // 1) Leí la última ciudad guardada
    final lastCity = await SharedPrefsHelper.getLastCity();
    // 2) Hice fetch de eventos
    final events = await _apiService.fetchEvents();

    // Actualicé el estado
    setState(() {
      if (lastCity != null && _cityFilterOptions.contains(lastCity)) {
        _selectedCityFilter = lastCity;
      }
      _allEvents = events;
      _applyCityFilter(); // Apliqué el filtro con la ciudad actual
    });
  }

  /// Apliqué el filtro según _selectedCityFilter
  void _applyCityFilter() {
    if (_selectedCityFilter == 'Todas') {
      _filteredEvents = List.from(_allEvents);
    } else {
      _filteredEvents = _allEvents.where((e) => e.city == _selectedCityFilter).toList();
    }
  }

  /// Cambié y guardé la ciudad elegida
  Future<void> _updateFilterCity(String newCity) async {
    // Actualicé la variable local en el mismo setState
    setState(() {
      _selectedCityFilter = newCity;
    });
    // Guardé en SharedPrefs
    await SharedPrefsHelper.saveLastCity(newCity);
    // Apliqué el filtro después
    setState(() {
      _applyCityFilter();
    });
  }

  /// Alterné el modo oscuro
  Future<void> _toggleDarkMode() async {
    final newValue = !_isDarkMode;
    setState(() {
      _isDarkMode = newValue;
    });
    await SharedPrefsHelper.saveDarkMode(newValue);
  }

  @override
  Widget build(BuildContext context) {
    // Definí colores según modo oscuro
    final backgroundColor = _isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black;
    final appBarColor = _isDarkMode ? Colors.grey[850] : Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('EnMiCiudad', style: TextStyle(color: textColor)),
        backgroundColor: appBarColor,
        actions: [
          // Mostré el botón de modo oscuro
          IconButton(
            icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode, color: textColor),
            tooltip: 'Cambiar modo oscuro/claro',
            onPressed: _toggleDarkMode,
          ),
          // Mostré el botón para crear
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Crear nuevo evento',
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/form');
              if (result == true) {
                final events = await _apiService.fetchEvents();
                setState(() {
                  _allEvents = events;
                  _applyCityFilter();
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Mostré la barra de selección de ciudad
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Filtrar ciudad:', style: TextStyle(color: textColor)),
                const SizedBox(width: 16),
                // Puse el filtro de ciudades con DropDown
                Expanded(
                  child: DropdownButton<String>(
                    dropdownColor: _isDarkMode ? Colors.grey[800] : Colors.white,
                    value: _selectedCityFilter,
                    items: _cityFilterOptions.map((city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city, style: TextStyle(color: textColor)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _updateFilterCity(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          // Mostré la lista de eventos filtrados
          Expanded(
            child: _filteredEvents.isEmpty
                ? Center(
              child: Text(
                'No hay eventos para "$_selectedCityFilter".',
                style: TextStyle(color: textColor),
              ),
            )
                : ListView.builder(
              itemCount: _filteredEvents.length,
              itemBuilder: (context, index) {
                final event = _filteredEvents[index];
                return EventCard(
                  event: event,
                  isDark: _isDarkMode,
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: event,
                    );
                    if (result == true) {
                      // Verifiqué si se editó/eliminó
                      final newEvents = await _apiService.fetchEvents();
                      setState(() {
                        _allEvents = newEvents;
                        _applyCityFilter();
                      });
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
