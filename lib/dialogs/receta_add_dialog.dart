import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proyecto_conde_ceramicas/model/receta_model.dart';
import 'package:image_picker/image_picker.dart';

class RecetaAddDialog extends StatefulWidget {
  final Function(Receta) onGuardar;

  const RecetaAddDialog({
    super.key,
    required this.onGuardar,
  });

  @override
  State<RecetaAddDialog> createState() => _RecetaAddDialogState();
}

class _RecetaAddDialogState extends State<RecetaAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  List<RecetaMateriaPrima> materiaPrima = [];

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

  String? imagenPath;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _seleccionarImagen() async {
    final XFile? imagen = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (imagen != null) {
      setState(() => imagenPath = imagen.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Añadir Receta'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: imagenPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(imagenPath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(Icons.image, size: 50, color: Colors.grey),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _seleccionarImagen,
                icon: Icon(Icons.photo),
                label: Text('Seleccionar Imagen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre Receta *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value?.isEmpty ?? true) ? 'Requerido' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => (value?.isEmpty ?? true) ? 'Requerido' : null,
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
              final receta = Receta(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                nombre: nombreController.text,
                descripcion: descripcionController.text,
                materiaPrima: materiaPrima,
                imagenReferencial: imagenPath
              );
              widget.onGuardar(receta);
              Navigator.pop(context);
            }
          },
          child: Text('Añadir'),
        ),
      ],
    );
  }
}
