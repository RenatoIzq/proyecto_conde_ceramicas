import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_conde_ceramicas/model/hornadas_model.dart';

class PlanifierDialog extends StatefulWidget {
  final DateTime fechaSeleccionada;
  final Function(Hornada) onPlanificar;

  const PlanifierDialog({
    super.key,
    required this.fechaSeleccionada,
    required this.onPlanificar,
  });

  @override
  State<PlanifierDialog> createState() => _PlanifierDialogState();
}

class _PlanifierDialogState extends State<PlanifierDialog> {
  final _formKey = GlobalKey<FormState>();
  String perfilSeleccionado = 'Bizcocho';
  TimeOfDay horaInicio = TimeOfDay(hour: 8, minute: 0);
  TextEditingController hornoController = TextEditingController();
  TextEditingController observacionesController = TextEditingController();

  @override
  void dispose() {
    hornoController.dispose();
    observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      title: Text('Planificar Hornada'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fecha (solo lectura)
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                ),
                initialValue: DateFormat(
                  'dd/MM/yyyy',
                ).format(widget.fechaSeleccionada),
              ),
              SizedBox(height: 12),

              // Hora Inicio
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: horaInicio,
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(
                          context,
                        ).copyWith(alwaysUse24HourFormat: false),
                        child: child!,
                      );
                    },
                  );
                  if (time != null) {
                    setState(() => horaInicio = time);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Hora Inicio',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(horaInicio.format(context)),
                      Icon(Icons.access_time),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Perfil de Temperatura
              DropdownButtonFormField<String>(
                initialValue: perfilSeleccionado,
                decoration: InputDecoration(
                  labelText: 'Perfil de Temperatura',
                  border: OutlineInputBorder(),
                ),
                items: ['Bizcocho', 'Esmalte'].map((perfil) {
                  return DropdownMenuItem(value: perfil, child: Text(perfil));
                }).toList(),
                onChanged: (value) {
                  setState(() => perfilSeleccionado = value!);
                },
              ),
              SizedBox(height: 12),

              // Horno
              TextFormField(
                controller: hornoController,
                decoration: InputDecoration(
                  labelText: 'Horno *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),

              // Observaciones
              TextFormField(
                controller: observacionesController,
                decoration: InputDecoration(
                  labelText: 'Observaciones',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final horaCompleta = DateTime(
                widget.fechaSeleccionada.year,
                widget.fechaSeleccionada.month,
                widget.fechaSeleccionada.day,
                horaInicio.hour,
                horaInicio.minute,
              );

              final nuevaHornada = Hornada(
                id: '',
                fechaPlanificada: widget.fechaSeleccionada,
                horaInicio: horaCompleta,
                perfilTemperatura: perfilSeleccionado,
                estado: 'Planificado',
                horno: hornoController.text,
                observaciones: observacionesController.text.isEmpty
                    ? null
                    : observacionesController.text,
              );

              widget.onPlanificar(nuevaHornada);
              Navigator.pop(context);
            }
          },
          child: Text('Planificar'),
        ),
      ],
    );
  }
}
