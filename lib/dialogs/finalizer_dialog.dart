import 'package:flutter/material.dart';
import 'package:proyecto_conde_ceramicas/model/hornadas_model.dart';

class DialogFinalizar extends StatelessWidget {
  final Hornada hornada;
  final Function(Hornada) onFinalizar;

  const DialogFinalizar({
    Key? key,
    required this.hornada,
    required this.onFinalizar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Finalizar Quema'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('¿Desea registrar el fin de esta quema?'),
          SizedBox(height: 16),
          Text(
            'Perfil: ${hornada.perfilTemperatura}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            'Horno: ${hornada.horno ?? '--'}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final hornadaFinalizada = Hornada(
              id: hornada.id,
              fechaPlanificada: hornada.fechaPlanificada,
              horaInicio: hornada.horaInicio,
              horaInicioReal: hornada.horaInicioReal,
              horaFin: DateTime.now(),
              perfilTemperatura: hornada.perfilTemperatura,
              estado: 'Finalizado',
              horno: hornada.horno,
              observaciones: hornada.observaciones,
            );

            onFinalizar(hornadaFinalizada);
            Navigator.pop(context);
          },
          child: Text('Finalizar'),
        ),
      ],
    );
  }
}
