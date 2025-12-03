import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/components/action_button.dart';
import 'package:proyecto_conde_ceramicas/components/search_filter_bar.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';
import 'package:proyecto_conde_ceramicas/model/inventario_model.dart';
import 'package:proyecto_conde_ceramicas/dialogs/inventario_add_dialog.dart';
import 'package:proyecto_conde_ceramicas/dialogs/inventario_edit_dialog.dart';
import 'package:proyecto_conde_ceramicas/dialogs/inventario_detail_dialog.dart';
import 'package:proyecto_conde_ceramicas/dialogs/delete_dialog.dart';
import 'package:proyecto_conde_ceramicas/services/inventario_service.dart';

class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key});

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  final InventarioService _inventarioService = InventarioService();

  String selectedFilter = 'Producto';
  final List<String> filterOptions = [
    'Producto',
    'Materia Prima',
    'Esmalte',
    'Molde',
  ];

  final TextEditingController searchController = TextEditingController();
  String searchTerm = '';

  InventarioItem? itemSeleccionado;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  IconData _getIconoPorTipo(String tipo) {
    switch (tipo) {
      case 'Producto':
        return Icons.shopping_bag;
      case 'Materia Prima':
        return Icons.grass;
      case 'Esmalte':
        return Icons.palette;
      case 'Molde':
        return Icons.category;
      default:
        return Icons.inventory;
    }
  }

  void _accionAnadir() {
    showDialog(
      context: context,
      builder: (dialogContext) => InventarioAddDialog(
        categorias: filterOptions,
        onGuardar: (item) async {
          try {
            await _inventarioService.addInventarioItem(item);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Item añadido correctamente'),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al añadir el item: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  void _accionEditar() {
    if (itemSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selecciona un item para editar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => InventarioEditDialog(
        item: itemSeleccionado!,
        categorias: filterOptions,
        onGuardar: (item) async {
          try {
            await _inventarioService.updateInventarioItem(item);
            if (!mounted) return;
            setState(() => itemSeleccionado = null);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Item editado correctamente'),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al editar el item: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  void _accionEliminar() {
    if (itemSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selecciona un item para eliminar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => DeleteDialog(
        titulo: 'Eliminar Item',
        mensaje: '¿Está seguro de eliminar este item?',
        detalles:
            'Código: ${itemSeleccionado!.codigo}\nNombre: ${itemSeleccionado!.nombre}',
        onConfirmar: () async {
          try {
            await _inventarioService.deleteInventarioItem(itemSeleccionado!.id);
            if (!mounted) return;
            setState(() => itemSeleccionado = null);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Item eliminado correctamente'),
                backgroundColor: Colors.red,
              ),
            );
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al eliminar el item: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: grisoscuro,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Inventario',
          style: GoogleFonts.oswald(color: Colors.white, fontSize: 30),
        ),
        flexibleSpace: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20, top: 30),
            child: Image.asset(
              'images/CONDECERAMICA-02.png',
              width: 50,
              height: 50,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.black],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SearchFilterBar(
                selectedFilter: selectedFilter,
                filterOptions: filterOptions,
                onFilterChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedFilter = newValue;
                      itemSeleccionado = null;
                    });
                  }
                },
                searchController: searchController,
                searchHintText: 'Nombre o Código',
                onSearchChanged: (value) {
                  setState(() => searchTerm = value);
                },
                onSearchSubmitted: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ActionButton(
                      text: 'Añadir',
                      onPressed: _accionAnadir,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<List<InventarioItem>>(
                  stream: _inventarioService.getInventario(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final datos = snapshot.data ?? [];
                    final itemsFiltrados = datos.where((item) {
                      final coincideFilter = item.tipo == selectedFilter;
                      final coincideBusqueda =
                          searchTerm.isEmpty ||
                          item.nombre.toLowerCase().contains(
                            searchTerm.toLowerCase(),
                          ) ||
                          item.codigo.toLowerCase().contains(
                            searchTerm.toLowerCase(),
                          );
                      return coincideFilter && coincideBusqueda;
                    }).toList();

                    if (itemsFiltrados.isEmpty) {
                      return Center(
                        child: Text(
                          'No hay items en esta categoría',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: itemsFiltrados.length,
                      itemBuilder: (context, index) {
                        final item = itemsFiltrados[index];
                        final esSeleccionado = itemSeleccionado?.id == item.id;

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          color: esSeleccionado
                              ? Colors.blue[50]
                              : Colors.white,
                          child: ListTile(
                            selected: esSeleccionado,
                            selectedTileColor: Colors.blue[50],
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) =>
                                    InventarioDetailDialog(
                                      item: item,
                                      onEditar: (item) {
                                        setState(() => itemSeleccionado = item);
                                        _accionEditar();
                                      },
                                      onEliminar: (item) {
                                        setState(() => itemSeleccionado = item);
                                        _accionEliminar();
                                      },
                                    ),
                              );
                            },
                            leading: Container(
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: item.getEstadoColor(),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: item.imagenReferencial != null
                                    ? (item.imagenReferencial!.startsWith(
                                            'http',
                                          )
                                          ? Image.network(
                                              item.imagenReferencial!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                      size: 40,
                                                    );
                                                  },
                                            )
                                          : Image.file(
                                              File(item.imagenReferencial!),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                      size: 40,
                                                    );
                                                  },
                                            ))
                                    : Icon(
                                        _getIconoPorTipo(item.tipo),
                                        color: item.getEstadoColor(),
                                        size: 40,
                                      ),
                              ),
                            ),
                            title: Text(
                              item.nombre,
                              style: GoogleFonts.oswald(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Código: ${item.codigo}'),
                                Text('${item.stockActual} ${item.unidad}'),
                                Chip(
                                  label: Text(
                                    item.getEstadoTexto(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                  backgroundColor: item.getEstadoColor(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
