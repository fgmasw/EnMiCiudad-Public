// Archivo: D:\06MASW-A1\en_mi_ciudad\lib\screens\form_screen.dart

import 'package:flutter/material.dart';
import 'package:en_mi_ciudad/models/event_model.dart';
import 'package:en_mi_ciudad/services/api_service.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

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

  // Para diferenciar si estamos en “Crear” o “Editar”
  Event? _editingEvent;

  @override
  void initState() {
    super.initState();

    // Verificar si recibimos un Event como argumento (modo edición)
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is Event) {
      _editingEvent = args;
    }

    // Inicializar controladores
    _titleController = TextEditingController(text: _editingEvent?.title ?? '');
    _categoryController = TextEditingController(text: _editingEvent?.category ?? '');
    _cityController = TextEditingController(text: _editingEvent?.city ?? '');
    _typeController = TextEditingController(text: _editingEvent?.type ?? '');
    _dateController = TextEditingController(text: _editingEvent?.date ?? '');
    _hourController = TextEditingController(text: _editingEvent?.hour ?? '');
    _locationController = TextEditingController(text: _editingEvent?.location ?? '');
    _priceController = TextEditingController(text: _editingEvent?.price ?? '');
    _descriptionController = TextEditingController(text: _editingEvent?.description ?? '');
  }

  @override
  void dispose() {
    // Liberar recursos
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

  // Acción al pulsar en “Guardar”
  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      // Recogemos los valores del form
      final eventData = Event(
        id: _editingEvent?.id, // null si estamos creando
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
          // Crear nuevo evento
          await _apiService.createEvent(eventData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Evento creado correctamente')),
          );
        } else {
          // Editar evento existente
          await _apiService.updateEvent(eventData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Evento actualizado correctamente')),
          );
        }

        // Volvemos a la pantalla anterior (o a Home)
        Navigator.pop(context, true);
        // Podemos devolver un bool para indicar “guardado con éxito”
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
          key: _formKey, // Clave para validar
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
