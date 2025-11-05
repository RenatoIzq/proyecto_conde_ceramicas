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

class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key});

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  String selectedFilter = 'Producto';
  final List<String> filterOptions = [
    'Producto',
    'Materia Prima',
    'Esmalte',
    'Molde',
  ];

  final TextEditingController searchController = TextEditingController();
  String searchTerm = '';
  
  late List<InventarioItem> inventarioItems;
  InventarioItem? itemSeleccionado;

  @override
  void initState() {
    super.initState();
    inventarioItems = [];
    _cargarDatosDePrueba();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _cargarDatosDePrueba() {
    inventarioItems = [
      InventarioItem(
        id: '1',
        nombre: 'Plato Decorativo',
        codigo: 'PROD-001',
        tipo: 'Producto',
        stockInicial: 100,
        stockActual: 85,
        unidad: 'piezas',
        estado: EstadoInventario.disponible,
      ),
      InventarioItem(
        id: '2',
        nombre: 'Taza Cerámica',
        codigo: 'PROD-002',
        tipo: 'Producto',
        stockInicial: 50,
        stockActual: 5,
        unidad: 'piezas',
        estado: EstadoInventario.bajo,
      ),
      InventarioItem(
        id: '3',
        nombre: 'Arcilla Blanca',
        codigo: 'ARC-001',
        tipo: 'Materia Prima',
        stockInicial: 500,
        stockActual: 450,
        unidad: 'kg',
        estado: EstadoInventario.disponible,
      ),
      InventarioItem(
        id: '4',
        nombre: 'Arcilla Roja',
        codigo: 'ARC-002',
        tipo: 'Materia Prima',
        stockInicial: 300,
        stockActual: 0,
        unidad: 'kg',
        estado: EstadoInventario.agotado,
      ),
      InventarioItem(
        id: '5',
        nombre: 'Esmalte Azul',
        codigo: 'ESM-001',
        tipo: 'Esmalte',
        stockInicial: 100,
        stockActual: 60,
        unidad: 'L',
        estado: EstadoInventario.disponible,
      ),
      InventarioItem(
        id: '7',
        nombre: 'Molde Cilindro',
        codigo: 'MOL-001',
        tipo: 'Molde',
        stockInicial: 20,
        stockActual: 18,
        unidad: 'piezas',
        estado: EstadoInventario.disponible,
      ),
    ];
  }

  List<InventarioItem> _obtenerItemsFiltrados() {
    return inventarioItems.where((item) {
      final coincideFilter = item.tipo == selectedFilter;
      final coincideBusqueda = searchTerm.isEmpty ||
          item.nombre.toLowerCase().contains(searchTerm.toLowerCase()) ||
          item.codigo.toLowerCase().contains(searchTerm.toLowerCase());
      return coincideFilter && coincideBusqueda;
    }).toList();
  }

  void _accionAnadir() {
    showDialog(
      context: context,
      builder: (context) => InventarioAddDialog(
        categorias: filterOptions,
        onGuardar: (item) {
          setState(() {
            inventarioItems.add(item);
            itemSeleccionado = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Item añadido correctamente'),
              backgroundColor: Colors.green,
            ),
          );
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
      builder: (context) => InventarioEditDialog(
        item: itemSeleccionado!,
        categorias: filterOptions,
        onGuardar: (item) {
          setState(() {
            final index = inventarioItems
                .indexWhere((i) => i.id == itemSeleccionado!.id);
            if (index != -1) {
              inventarioItems[index] = item;
            }
            itemSeleccionado = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Item actualizado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
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
      builder: (context) => DeleteDialog(
        titulo: 'Eliminar Item',
        mensaje: '¿Está seguro de eliminar este item?',
        detalles: 'Código: ${itemSeleccionado!.codigo}\nNombre: ${itemSeleccionado!.nombre}',
        onConfirmar: () {
          setState(() {
            inventarioItems.removeWhere((i) => i.id == itemSeleccionado!.id);
            itemSeleccionado = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Item eliminado correctamente'),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemsFiltrados = _obtenerItemsFiltrados();

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
                child: itemsFiltrados.isEmpty
                    ? Center(
                        child: Text(
                          'No hay items en esta categoría',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: itemsFiltrados.length,
                        itemBuilder: (context, index) {
                          final item = itemsFiltrados[index];
                          final esSeleccionado = itemSeleccionado?.id == item.id;

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            color: esSeleccionado ? Colors.blue[50] : Colors.white,
                            child: ListTile(
                              selected: esSeleccionado,
                              selectedTileColor: Colors.blue[50],
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => InventarioDetailDialog(
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
                                width: 50,
                                decoration: BoxDecoration(
                                  color: item.getEstadoColor(),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    item.stockActual.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
