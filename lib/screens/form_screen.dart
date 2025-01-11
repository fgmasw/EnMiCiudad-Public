// Guardé este archivo en: D:\06MASW-A1\en_mi_ciudad\lib\screens\form_screen.dart

import 'package:flutter/material.dart';
import 'package:en_mi_ciudad/models/event_model.dart';
import 'package:en_mi_ciudad/services/api_service.dart';

// Importé el helper de SharedPreferences para isDarkMode()
import 'package:en_mi_ciudad/utils/shared_prefs_helper.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  // Definí la key del formulario y el servicio de API
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Declaré los controladores para los campos
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  // Definí las listas para los dropdown
  final List<String> _categoryList = [
    'fiestas',
    'arte',
    'geek',
    'congresos',
    'infantil',
    'moda',
    'deportes',
    'otros',
  ];
  final List<String> _typeList = [
    'Presencial',
    'Online',
    'Híbrido',
  ];
  final List<String> _cityList = [
    'Sao Paulo',
    'Rio de Janeiro',
  ];

  // Declaré las variables para dropdown
  String? _selectedCategory;
  String? _selectedType;
  String? _selectedCity;

  // Definí estas variables para la fecha y la hora
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Configuré el evento en modo edición
  Event? _editingEvent;
  bool _didLoadArgs = false;

  // Declaré la variable para modo oscuro
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // Inicialicé los controladores
    _titleController = TextEditingController();
    _locationController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();

    // Cargué el modo oscuro desde SharedPreferences
    _loadDarkMode();
  }

  /// Cargué el flag de modo oscuro desde SharedPreferences
  Future<void> _loadDarkMode() async {
    final dark = await SharedPrefsHelper.isDarkMode();
    setState(() {
      _isDarkMode = dark;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoadArgs) {
      // Revisé si llegaron argumentos de edición
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Event) {
        _editingEvent = args;

        // Cargué datos en los TextField
        _titleController.text = _editingEvent?.title ?? '';
        _locationController.text = _editingEvent?.location ?? '';
        _priceController.text = _editingEvent?.price ?? '';
        _descriptionController.text = _editingEvent?.description ?? '';

        // Cargué valores en los dropdowns
        _selectedCategory = _editingEvent?.category;
        _selectedType = _editingEvent?.type;
        _selectedCity = _editingEvent?.city;

        // Cargué la fecha (yyyy-MM-dd)
        if (_editingEvent?.date != null && _editingEvent!.date.isNotEmpty) {
          try {
            _selectedDate = DateTime.parse(_editingEvent!.date);
          } catch (_) {}
        }

        // Cargué la hora (HH:MM)
        if (_editingEvent?.hour != null && _editingEvent!.hour.isNotEmpty) {
          final parts = _editingEvent!.hour.split(':');
          if (parts.length == 2) {
            final hh = int.tryParse(parts[0]) ?? 0;
            final mm = int.tryParse(parts[1]) ?? 0;
            _selectedTime = TimeOfDay(hour: hh, minute: mm);
          }
        }
      }
      _didLoadArgs = true;
    }
  }

  @override
  void dispose() {
    // Liberé los controladores
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Abrí el selector de fecha
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Abrí el selector de hora
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Guardé el evento con validación y manejo de creación/edición
  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      // Generé u obtuve el ID
      String? finalId = _editingEvent?.id;
      if (_editingEvent == null) {
        finalId = await _apiService.getNextSequentialId();
      }

      // Convertí fecha y hora a String
      String dateString = '';
      if (_selectedDate != null) {
        dateString =
        "${_selectedDate!.year.toString().padLeft(4, '0')}"
            "-${_selectedDate!.month.toString().padLeft(2, '0')}"
            "-${_selectedDate!.day.toString().padLeft(2, '0')}";
      }

      String hourString = '';
      if (_selectedTime != null) {
        final hh = _selectedTime!.hour.toString().padLeft(2, '0');
        final mm = _selectedTime!.minute.toString().padLeft(2, '0');
        hourString = "$hh:$mm";
      }

      final eventData = Event(
        id: finalId,
        title: _titleController.text.trim(),
        category: _selectedCategory ?? 'otros',
        city: _selectedCity ?? 'Sao Paulo',
        type: _selectedType ?? 'Presencial',
        date: dateString,
        hour: hourString,
        location: _locationController.text.trim(),
        price: _priceController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      try {
        if (_editingEvent == null) {
          // Creé un nuevo evento
          await _apiService.createEvent(eventData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Evento creado correctamente')),
          );
        } else {
          // Actualicé un evento existente
          await _apiService.updateEvent(eventData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Evento actualizado correctamente')),
          );
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el evento: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verifiqué si era edición
    final isEditMode = _editingEvent != null;
    final titleAppBar = isEditMode ? 'Editar Evento' : 'Nuevo Evento';

    // Definí colores según _isDarkMode
    final backgroundColor = _isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black;
    final appBarColor = _isDarkMode ? Colors.grey[850] : Theme.of(context).primaryColor;

    // Convertí la fecha/hora a String
    final dateText = _selectedDate == null
        ? ''
        : "${_selectedDate!.year.toString().padLeft(4, '0')}"
        "-${_selectedDate!.month.toString().padLeft(2, '0')}"
        "-${_selectedDate!.day.toString().padLeft(2, '0')}";

    final timeText = _selectedTime == null
        ? ''
        : "${_selectedTime!.hour.toString().padLeft(2, '0')}"
        ":${_selectedTime!.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          titleAppBar,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: DefaultTextStyle(
            // Apliqué el color de texto por defecto a los children
            style: TextStyle(color: textColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Definí el campo para el título
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Título',
                    hintText: 'Ej: Concierto de Rock',
                    labelStyle: TextStyle(color: textColor),
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa el título.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Definí el campo para la categoría (dropdown)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    labelStyle: TextStyle(color: textColor),
                  ),
                  iconEnabledColor: textColor,
                  dropdownColor: _isDarkMode ? Colors.grey[800] : Colors.white,
                  value: _selectedCategory ?? _categoryList.first,
                  items: _categoryList.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 10),

                // Definí el campo para la ciudad (dropdown)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Ciudad',
                    labelStyle: TextStyle(color: textColor),
                  ),
                  iconEnabledColor: textColor,
                  dropdownColor: _isDarkMode ? Colors.grey[800] : Colors.white,
                  value: _selectedCity ?? _cityList.first,
                  items: _cityList.map((city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value;
                    });
                  },
                ),
                const SizedBox(height: 10),

                // Definí el campo para el tipo (dropdown)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Tipo',
                    labelStyle: TextStyle(color: textColor),
                  ),
                  iconEnabledColor: textColor,
                  dropdownColor: _isDarkMode ? Colors.grey[800] : Colors.white,
                  value: _selectedType ?? _typeList.first,
                  items: _typeList.map((tipo) {
                    return DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                const SizedBox(height: 10),

                // Manejé la selección de fecha
                Text(
                  'Fecha (AAAA-MM-DD)',
                  style: TextStyle(color: textColor),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(dateText.isEmpty ? 'Sin fecha' : dateText),
                    ),
                    ElevatedButton(
                      onPressed: _pickDate,
                      child: const Text('Elegir fecha'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Manejé la selección de hora
                Text(
                  'Hora (HH:MM)',
                  style: TextStyle(color: textColor),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(timeText.isEmpty ? 'Sin hora' : timeText),
                    ),
                    ElevatedButton(
                      onPressed: _pickTime,
                      child: const Text('Elegir hora'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Definí el campo para la ubicación
                TextFormField(
                  controller: _locationController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Ubicación',
                    hintText: 'Ej: Plaza Central / Online...',
                    labelStyle: TextStyle(color: textColor),
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Definí el campo para el precio
                TextFormField(
                  controller: _priceController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Precio',
                    hintText: 'Ej: R\$ 50, R\$ 0 (gratis)',
                    labelStyle: TextStyle(color: textColor),
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Definí el campo para la descripción
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Describe el evento...',
                    labelStyle: TextStyle(color: textColor),
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Añadí el botón para guardar
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _saveEvent,
                    child: Text(isEditMode ? 'Actualizar' : 'Crear'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
