import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_conde_ceramicas/model/inventario_model.dart';

class InventarioEditDialog extends StatefulWidget {
  final InventarioItem item;
  final List<String> categorias;
  final Function(InventarioItem) onGuardar;

  const InventarioEditDialog({
    super.key,
    required this.item,
    required this.categorias,
    required this.onGuardar,
  });

  @override
  State<InventarioEditDialog> createState() => _InventarioEditDialogState();
}

class _InventarioEditDialogState extends State<InventarioEditDialog> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController nombreController;
  late TextEditingController codigoController;
  late TextEditingController stockInicialController;
  late TextEditingController stockActualController;
  
  late String tipoSeleccionado;
  String? imagenPath;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    nombreController = TextEditingController(text: widget.item.nombre);
    codigoController = TextEditingController(text: widget.item.codigo);
    stockInicialController = TextEditingController(
      text: widget.item.stockInicial.toString(),
    );
    stockActualController = TextEditingController(
      text: widget.item.stockActual.toString(),
    );
    tipoSeleccionado = widget.item.tipo;
    imagenPath = widget.item.imagenReferencial;
  }

  @override
  void dispose() {
    nombreController.dispose();
    codigoController.dispose();
    stockInicialController.dispose();
    stockActualController.dispose();
    super.dispose();
  }

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
      title: Text('Editar Item'),
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
                    ? Image.file(File(imagenPath!), fit: BoxFit.cover)
                    : Icon(Icons.image, size: 50, color: Colors.grey),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _seleccionarImagen,
                icon: Icon(Icons.photo),
                label: Text('Cambiar Imagen'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: codigoController,
                decoration: InputDecoration(
                  labelText: 'Código *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value?.isEmpty ?? true) ? 'Requerido' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value?.isEmpty ?? true) ? 'Requerido' : null,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: tipoSeleccionado,
                decoration: InputDecoration(
                  labelText: 'Categoría *',
                  border: OutlineInputBorder(),
                ),
                items: widget.categorias.map((tipo) {
                  return DropdownMenuItem(value: tipo, child: Text(tipo));
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => tipoSeleccionado = value);
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: stockInicialController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock Inicial *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Requerido';
                  if (int.tryParse(value!) == null) return 'Debe ser un número';
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: stockActualController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock Actual *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Requerido';
                  if (int.tryParse(value!) == null) return 'Debe ser un número';
                  return null;
                },
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
              final itemActualizado = widget.item.copyWith(
                nombre: nombreController.text,
                codigo: codigoController.text,
                tipo: tipoSeleccionado,
                stockInicial: int.parse(stockInicialController.text),
                stockActual: int.parse(stockActualController.text),
                imagenReferencial: imagenPath,
              );
              widget.onGuardar(itemActualizado);
              Navigator.pop(context);
            }
          },
          child: Text('Actualizar'),
        ),
      ],
    );
  }
}
