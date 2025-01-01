// Archivo: D:\06MASW-A1\en_mi_ciudad\lib\screens\form_screen.dart

import 'package:flutter/material.dart';
import 'package:en_mi_ciudad/models/event_model.dart';
import 'package:en_mi_ciudad/services/api_service.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Controladores para los campos del formulario
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _cityController;
  late TextEditingController _typeController;
  late TextEditingController _dateController;
  late TextEditingController _hourController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  // Modo creación o edición
  Event? _editingEvent;
  bool _didLoadArgs = false;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con strings vacíos
    _titleController = TextEditingController();
    _categoryController = TextEditingController();
    _cityController = TextEditingController();
    _typeController = TextEditingController();
    _dateController = TextEditingController();
    _hourController = TextEditingController();
    _locationController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoadArgs) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Event) {
        _editingEvent = args;
        _titleController.text = _editingEvent?.title ?? '';
        _categoryController.text = _editingEvent?.category ?? '';
        _cityController.text = _editingEvent?.city ?? '';
        _typeController.text = _editingEvent?.type ?? '';
        _dateController.text = _editingEvent?.date ?? '';
        _hourController.text = _editingEvent?.hour ?? '';
        _locationController.text = _editingEvent?.location ?? '';
        _priceController.text = _editingEvent?.price ?? '';
        _descriptionController.text = _editingEvent?.description ?? '';
      }
      _didLoadArgs = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _cityController.dispose();
    _typeController.dispose();
    _dateController.dispose();
    _hourController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      // Si estamos CREANDO (sin _editingEvent), calculamos un ID secuencial
      String? finalId = _editingEvent?.id; // si editamos, conservamos su ID
      if (_editingEvent == null) {
        // Obtener el siguiente ID secuencial
        finalId = await _apiService.getNextSequentialId();
      }

      // Construir el Event con la ID correspondiente
      final eventData = Event(
        id: finalId,
        title: _titleController.text.trim(),
        category: _categoryController.text.trim(),
        city: _cityController.text.trim(),
        type: _typeController.text.trim(),
        date: _dateController.text.trim(),
        hour: _hourController.text.trim(),
        location: _locationController.text.trim(),
        price: _priceController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      try {
        if (_editingEvent == null) {
          // Crear
          await _apiService.createEvent(eventData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Evento creado correctamente')),
          );
        } else {
          // Editar
          await _apiService.updateEvent(eventData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Evento actualizado correctamente')),
          );
        }

        // Retornamos true para indicar que se guardó algo
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
    final isEditMode = _editingEvent != null;
    final titleAppBar = isEditMode ? 'Editar Evento' : 'Nuevo Evento';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleAppBar),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  hintText: 'Ej: Concierto de Rock',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el título.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Categoría
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  hintText: 'Ej: fiestas, arte, geek...',
                ),
              ),
              const SizedBox(height: 10),

              // Ciudad
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Ciudad',
                  hintText: 'Ej: Rio de Janeiro, Sao Paulo...',
                ),
              ),
              const SizedBox(height: 10),

              // Tipo
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  hintText: 'Online o Presencial',
                ),
              ),
              const SizedBox(height: 10),

              // Fecha
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  hintText: '2025-01-01',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la fecha.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Hora
              TextFormField(
                controller: _hourController,
                decoration: const InputDecoration(
                  labelText: 'Hora',
                  hintText: 'HH:MM',
                ),
              ),
              const SizedBox(height: 10),

              // Ubicación
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Ubicación',
                  hintText: 'Ej: Plaza Central / Online...',
                ),
              ),
              const SizedBox(height: 10),

              // Precio
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  hintText: 'Ej: R\$ 50, R\$ 0 (gratis)',
                ),
              ),
              const SizedBox(height: 10),

              // Descripción
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Describe el evento...',
                ),
              ),
              const SizedBox(height: 20),

              // Botón Guardar
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
    );
  }
}
