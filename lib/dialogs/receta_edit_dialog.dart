import 'package:flutter/material.dart';
import 'package:proyecto_conde_ceramicas/model/receta_model.dart';

class RecetaEditDialog extends StatefulWidget {
  final Receta receta;
  final Function(Receta) onGuardar;

  const RecetaEditDialog({
    super.key,
    required this.receta,
    required this.onGuardar,
  });

  @override
  State<RecetaEditDialog> createState() => _RecetaEditDialogState();
}

class _RecetaEditDialogState extends State<RecetaEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreController;
  late TextEditingController descripcionController;
  late List<RecetaMateriaPrima> materiaPrima;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.receta.nombre);
    descripcionController = TextEditingController(text: widget.receta.descripcion);
    materiaPrima = List.from(widget.receta.materiaPrima);
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  void _agregarMateriaPrima() {
    setState(() {
      materiaPrima.add(
        RecetaMateriaPrima(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nombre: '',
          proporcion: 0,
        ),
      );
    });
  }

  void _eliminarMateriaPrima(int index) {
    setState(() => materiaPrima.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar Receta'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre Receta',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              Text(
                'Materias Primas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...List.generate(
                materiaPrima.length,
                (index) {
                  final mp = materiaPrima[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: mp.nombre,
                            decoration: InputDecoration(
                              labelText: 'Nombre',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onChanged: (value) {
                              materiaPrima[index] = mp.copyWith(nombre: value);
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            initialValue: mp.proporcion.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: '%',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onChanged: (value) {
                              materiaPrima[index] = mp.copyWith(
                                proporcion: double.tryParse(value) ?? 0,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _eliminarMateriaPrima(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ElevatedButton.icon(
                onPressed: _agregarMateriaPrima,
                icon: Icon(Icons.add),
                label: Text('Añadir Materia Prima'),
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
              final recetaActualizada = widget.receta.copyWith(
                nombre: nombreController.text,
                descripcion: descripcionController.text,
                materiaPrima: materiaPrima,
              );
              widget.onGuardar(recetaActualizada);
              Navigator.pop(context);
            }
          },
          child: Text('Actualizar'),
        ),
      ],
    );
  }
}
