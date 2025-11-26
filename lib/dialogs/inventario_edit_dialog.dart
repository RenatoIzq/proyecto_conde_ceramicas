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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreController;
  late TextEditingController codigoController;
  late TextEditingController stockInicialController;
  late TextEditingController stockActualController;
  late TextEditingController unidadController;

  late String tipoSeleccionado;
  late EstadoProducto estadoProductoSeleccionado;
  late EstadoStock estadoStockSeleccionado;
  String? imagenPath;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.item.nombre);
    codigoController = TextEditingController(text: widget.item.codigo);
    stockInicialController = TextEditingController(
      text: widget.item.stockInicial.toString(),
    );
    stockActualController = TextEditingController(
      text: widget.item.stockActual.toString(),
    );
    unidadController = TextEditingController(text: widget.item.unidad);
    tipoSeleccionado = widget.item.tipo;
    estadoProductoSeleccionado =
        widget.item.estadoProducto ?? EstadoProducto.crudo;
    estadoStockSeleccionado = widget.item.estadoStock ?? EstadoStock.disponible;
    imagenPath = widget.item.imagenReferencial;
  }

  @override
  void dispose() {
    nombreController.dispose();
    codigoController.dispose();
    stockInicialController.dispose();
    stockActualController.dispose();
    unidadController.dispose();
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
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Código',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          codigoController.text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.lock, color: Colors.grey),
                  ],
                ),
              ),
              SizedBox(height: 12),
              SizedBox(height: 12),
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: tipoSeleccionado,
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: widget.categorias.map((tipo) {
                  return DropdownMenuItem(value: tipo, child: Text(tipo));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      tipoSeleccionado = value;
                      estadoProductoSeleccionado = EstadoProducto.crudo;
                      estadoStockSeleccionado = EstadoStock.disponible;
                    });
                  }
                },
              ),
              SizedBox(height: 12),
              // ✅ DROPDOWN DE ESTADO (solo para Productos)
              if (tipoSeleccionado == 'Producto')
                DropdownButtonFormField<EstadoProducto>(
                  initialValue: estadoProductoSeleccionado,
                  decoration: InputDecoration(
                    labelText: 'Estado de Producción',
                    border: OutlineInputBorder(),
                  ),
                  items: EstadoProducto.values.map((estado) {
                    String texto = '';
                    switch (estado) {
                      case EstadoProducto.crudo:
                        texto = 'Crudo';
                        break;
                      case EstadoProducto.bizcocho:
                        texto = 'Bizcocho';
                        break;
                      case EstadoProducto.esmaltado:
                        texto = 'Esmaltado';
                        break;
                      case EstadoProducto.terminado:
                        texto = 'Finalizado';
                        break;
                    }
                    return DropdownMenuItem(value: estado, child: Text(texto));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => estadoProductoSeleccionado = value);
                    }
                  },
                )
              else
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Estado: Se calculará automáticamente según el stock',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              SizedBox(height: 12),
              TextFormField(
                controller: stockInicialController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock Inicial',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (int.tryParse(value!) == null) return 'Debe ser un número';
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: stockActualController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock Actual',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (int.tryParse(value!) == null) return 'Debe ser un número';
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: unidadController,
                decoration: InputDecoration(
                  labelText: 'Unidad',
                  border: OutlineInputBorder(),
                ),
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
              final stockInicial = int.parse(stockInicialController.text);
              final stockActual = int.parse(stockActualController.text);

              final itemActualizado = widget.item.copyWith(
                nombre: nombreController.text,
                tipo: tipoSeleccionado,
                stockInicial: stockInicial,
                stockActual: stockActual,
                unidad: unidadController.text,
                estadoProducto: tipoSeleccionado == 'Producto'
                    ? estadoProductoSeleccionado
                    : null,
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
