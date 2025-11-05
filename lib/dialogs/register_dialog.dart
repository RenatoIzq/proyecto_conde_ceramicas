import 'package:flutter/material.dart';
import 'package:proyecto_conde_ceramicas/model/hornadas_model.dart';

class RegisterDialog extends StatefulWidget {
  final Hornada hornada;
  final Function(Hornada) onRegistrar;
  final Function(Hornada) onEliminar;

  const RegisterDialog({
    super.key,
    required this.hornada,
    required this.onRegistrar,
    required this.onEliminar,
  });

  @override
  State<RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  TimeOfDay horaInicioReal = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Registrar Hornada'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hora Inicio Programada (solo lectura)
          Row(
            children: [
              Expanded(
                child: Text(
                  'Hora Inicio',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                widget.hornada.horaInicio != null
                    ? TimeOfDay.fromDateTime(
                        widget.hornada.horaInicio!,
                      ).format(context)
                    : '--:--',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Divider(height: 24),

          // Hora Inicio Real
          InkWell(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: horaInicioReal,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(
                      context
                    ).copyWith(alwaysUse24HourFormat: false),
                    child: child!,
                  );
                },
              );
              if (time != null) {
                setState(() => horaInicioReal = time);
              }
            },
            
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Hora Inicio Real',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  horaInicioReal.format(context),
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
                SizedBox(width: 4),
                Icon(Icons.access_time, size: 20, color: Colors.blue),
              ],
            ),
          ),
          Divider(height: 24),

          // Estado (solo lectura)
          Row(
            children: [
              Expanded(
                child: Text(
                  'Estado',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Text(widget.hornada.estado),
            ],
          ),
          Divider(height: 24),

          // Horno (solo lectura)
          Row(
            children: [
              Expanded(
                child: Text(
                  'Horno',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Text(widget.hornada.horno ?? '--'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // Mostrar confirmación de eliminación
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Eliminar Planificación'),
                content: Text('¿Está seguro de eliminar esta planificación?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.onEliminar(widget.hornada);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Eliminar'),
                  ),
                ],
              ),
            );
          },
          child: Text('Eliminar', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final horaCompleta = DateTime(
              widget.hornada.fechaPlanificada.year,
              widget.hornada.fechaPlanificada.month,
              widget.hornada.fechaPlanificada.day,
              horaInicioReal.hour,
              horaInicioReal.minute,
            );

            final hornadaActualizada = Hornada(
              id: widget.hornada.id,
              fechaPlanificada: widget.hornada.fechaPlanificada,
              horaInicio: widget.hornada.horaInicio,
              horaInicioReal: horaCompleta,
              perfilTemperatura: widget.hornada.perfilTemperatura,
              estado: 'En Curso',
              horno: widget.hornada.horno,
              observaciones: widget.hornada.observaciones,
            );

            widget.onRegistrar(hornadaActualizada);
            Navigator.pop(context);
          },
          child: Text('Iniciar'),
        ),
      ],
    );
  }
}
