import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/components/action_button.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';
import 'package:proyecto_conde_ceramicas/model/receta_model.dart';
import 'package:proyecto_conde_ceramicas/dialogs/receta_add_dialog.dart';
import 'package:proyecto_conde_ceramicas/dialogs/receta_edit_dialog.dart';
import 'package:proyecto_conde_ceramicas/dialogs/receta_detail_dialog.dart';
import 'package:proyecto_conde_ceramicas/dialogs/delete_dialog.dart';

class RecetasPage extends StatefulWidget {
  const RecetasPage({super.key});

  @override
  State<RecetasPage> createState() => _RecetasPageState();
}

class _RecetasPageState extends State<RecetasPage> {
  final TextEditingController searchController = TextEditingController();
  String searchTerm = '';
  
  late List<Receta> recetas;
  Receta? recetaSeleccionada;

  @override
  void initState() {
    super.initState();
    recetas = [];
    _cargarDatosDePrueba();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _cargarDatosDePrueba() {
    recetas = [
      Receta(
        id: '1',
        nombre: 'Esmalte Azul Cobalto',
        descripcion: 'Esmalte brillante de color azul intenso, ideal para piezas decorativas.',
        materiaPrima: [
          RecetaMateriaPrima(id: '1', nombre: 'Feldespato', proporcion: 30),
          RecetaMateriaPrima(id: '2', nombre: 'Caolín', proporcion: 25),
          RecetaMateriaPrima(id: '3', nombre: 'Óxido de Cobalto', proporcion: 5),
        ],
      ),
      Receta(
        id: '2',
        nombre: 'Esmalte Rojo Oscuro',
        descripcion: 'Esmalte mate de tonos rojos profundos.',
        materiaPrima: [
          RecetaMateriaPrima(id: '4', nombre: 'Feldespato', proporcion: 28),
          RecetaMateriaPrima(id: '5', nombre: 'Caolín', proporcion: 22),
          RecetaMateriaPrima(id: '6', nombre: 'Óxido de Hierro', proporcion: 8),
        ],
      ),
      Receta(
        id: '3',
        nombre: 'Bizcocho Base',
        descripcion: 'Esmalte base para hornadas de bizcocho.',
        materiaPrima: [
          RecetaMateriaPrima(id: '7', nombre: 'Feldespato', proporcion: 35),
          RecetaMateriaPrima(id: '8', nombre: 'Caolín', proporcion: 30),
        ],
      ),
    ];
  }

  List<Receta> _obtenerRecetasFiltradas() {
    return recetas.where((receta) {
      return searchTerm.isEmpty ||
          receta.nombre.toLowerCase().contains(searchTerm.toLowerCase()) ||
          receta.descripcion.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
  }

  void _accionAnadir() {
    showDialog(
      context: context,
      builder: (context) => RecetaAddDialog(
        onGuardar: (receta) {
          setState(() {
            recetas.add(receta);
            recetaSeleccionada = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Receta añadida correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _accionEditar() {
    if (recetaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selecciona una receta para editar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => RecetaEditDialog(
        receta: recetaSeleccionada!,
        onGuardar: (receta) {
          setState(() {
            final index = recetas.indexWhere((r) => r.id == recetaSeleccionada!.id);
            if (index != -1) {
              recetas[index] = receta;
            }
            recetaSeleccionada = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Receta actualizada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _accionEliminar() {
    if (recetaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selecciona una receta para eliminar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => DeleteDialog(
        titulo: 'Eliminar Receta',
        mensaje: '¿Está seguro de eliminar esta receta?',
        detalles: 'Receta: ${recetaSeleccionada!.nombre}',
        onConfirmar: () {
          setState(() {
            recetas.removeWhere((r) => r.id == recetaSeleccionada!.id);
            recetaSeleccionada = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Receta eliminada correctamente'),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recetasFiltradas = _obtenerRecetasFiltradas();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: grisoscuro,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Recetario',
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
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar receta...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  setState(() => searchTerm = value);
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
                child: recetasFiltradas.isEmpty
                    ? Center(
                        child: Text(
                          'No hay recetas disponibles',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: recetasFiltradas.length,
                        itemBuilder: (context, index) {
                          final receta = recetasFiltradas[index];
                          final esSeleccionada = recetaSeleccionada?.id == receta.id;

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            color: esSeleccionada ? Colors.blue[50] : Colors.white,
                            child: ListTile(
                              selected: esSeleccionada,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => RecetaDetailDialog(
                                    receta: receta,
                                    onEditar: (receta) {
                                      setState(() => recetaSeleccionada = receta);
                                      _accionEditar();
                                    },
                                    onEliminar: (receta) {
                                      setState(() => recetaSeleccionada = receta);
                                      _accionEliminar();
                                    },
                                  ),
                                );
                              },
                              leading: Container(
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.local_florist,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: Text(
                                receta.nombre,
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    receta.descripcion,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${receta.materiaPrima.length} materias primas',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
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
