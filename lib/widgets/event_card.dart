// Archivo: D:\06MASW-A1\en_mi_ciudad\lib\widgets\event_card.dart

import 'package:flutter/material.dart';
import 'package:en_mi_ciudad/models/event_model.dart';

/// Un widget que muestra un [Event] en forma de tarjeta (Card).
/// Puede usarse en listas, grid o en cualquier parte de la UI.
/// [onTap] es opcional: se invoca al tocar la tarjeta (por ejemplo, para navegar a detail).
class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;

  const EventCard({
    Key? key,
    required this.event,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // Para que el Card sea "tappable", podemos envolverlo en InkWell o GestureDetector
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título del evento
              Text(
                event.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              // Fecha y hora
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 4),
                  Text(
                    event.date,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Icon(Icons.access_time, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 4),
                  Text(
                    event.hour,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Ciudad
              Row(
                children: [
                  Icon(Icons.location_city, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.city,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Precio
              Text(
                'Precio: ${event.price}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // (Opcional) Categoría y/o tipo
              // const SizedBox(height: 6),
              // Text(
              //   'Categoría: ${event.category}',
              //   style: Theme.of(context).textTheme.bodySmall,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
