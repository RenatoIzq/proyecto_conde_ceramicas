import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String titulo;
  final String mensaje;
  final String? detalles;
  final Function() onConfirmar;

  const DeleteDialog({
    super.key,
    required this.titulo,
    required this.mensaje,
    this.detalles,
    required this.onConfirmar,
    });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mensaje),
          if (detalles != null) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[100],
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                detalles!,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            )
       
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirmar();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: Text('Eliminar'),
        ),
      ],
    );
  }
}