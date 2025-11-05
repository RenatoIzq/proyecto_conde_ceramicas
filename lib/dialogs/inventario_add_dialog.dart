import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_conde_ceramicas/model/inventario_model.dart';

class InventarioAddDialog extends StatefulWidget {
  final List<String> categorias;
  final Function(InventarioItem) onGuardar;
  

  const InventarioAddDialog({
    super.key,
    required this.categorias,
    required this.onGuardar,
  });

  @override
  State<InventarioAddDialog> createState() => _InventarioAddDialogState();
}

class _InventarioAddDialogState extends State<InventarioAddDialog> {
  final _formKey = GlobalKey<FormState>(); 
  final nombreController = TextEditingController();  
  final codigoController = TextEditingController();  
  final stockInicialController = TextEditingController();  
  final stockActualController = TextEditingController();

  late String tipoSeleccionado;
  EstadoProducto estadoProductoSeleccionado = EstadoProducto.crudo;
  EstadoStock estadoStockSeleccionado = EstadoStock.disponible;
  String? imagenPath;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    tipoSeleccionado = widget.categorias.first;
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
      title: Text('Añadir Item'),
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
                label: Text('Seleccionar Imagen'),
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
                initialValue: tipoSeleccionado,
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
              //Si es un producto mostrar estado de produccion, si no mostrar estado de stock
              SizedBox(height: 12),
              if (tipoSeleccionado == 'Producto')
                DropdownButtonFormField<EstadoProducto>(
                  initialValue: estadoProductoSeleccionado,
                  decoration: InputDecoration(
                    labelText: 'Estado de Producción *',
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
                    if (value != null) setState(() => estadoProductoSeleccionado = value);
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
              final stockInicial = int.parse(stockInicialController.text);
              final stockActual = int.parse(stockActualController.text);

              final item = InventarioItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                nombre: nombreController.text,
                codigo: codigoController.text,
                tipo: tipoSeleccionado,
                stockInicial: stockInicial,
                stockActual: stockActual,
                unidad: 'piezas',
                // ✅ Asigna los estados correctamente
                estadoProducto: tipoSeleccionado == 'Producto'
                    ? estadoProductoSeleccionado
                    : null,
                estadoStock: tipoSeleccionado != 'Producto'
                    ? InventarioItem.determinarEstadoStock(
                        stockActual,
                        stockInicial,
                      )
                    : null,
                imagenReferencial: imagenPath,

              );
              widget.onGuardar(item);
              Navigator.pop(context);
            }
          },
          child: Text('Añadir'),
        ),
      ],
    );
  }
}