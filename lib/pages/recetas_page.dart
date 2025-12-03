import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/components/action_button.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';
import 'package:proyecto_conde_ceramicas/model/receta_model.dart';
import 'package:proyecto_conde_ceramicas/services/receta_service.dart';
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
  final RecetaService _recetaService = RecetaService();

  late Future<List<Receta>> _recetasFuture;
  Receta? recetaSeleccionada;

  @override
  void initState() {
    super.initState();
    _loadRecetas();
  }

  void _loadRecetas() {
    setState(() {
      _recetasFuture = _recetaService.getRecetas();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Receta> _filtrarRecetas(List<Receta> recetas) {
    if (searchTerm.isEmpty) return recetas;
    return recetas.where((receta) {
      return receta.nombre.toLowerCase().contains(searchTerm.toLowerCase()) ||
          receta.descripcion.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
  }

  void _accionAnadir() {
    showDialog(
      context: context,
      builder: (_) => RecetaAddDialog(
        onGuardar: (receta) async {
          try {
            await _recetaService.addReceta(receta);
            if (!mounted) {
              return;
            }
            _loadRecetas(); // Refresh list
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Receta añadida correctamente'),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            if (!mounted) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al añadir receta: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  void _accionEditar(Receta receta) {
    showDialog(
      context: context,
      builder: (_) => RecetaEditDialog(
        receta: receta,
        onGuardar: (recetaActualizada) async {
          try {
            await _recetaService.updateReceta(recetaActualizada);
            if (!mounted) {
              return;
            }
            _loadRecetas(); // Refresh list
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Receta actualizada correctamente'),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            if (!mounted) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al actualizar receta: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  void _accionEliminar(Receta receta) {
    showDialog(
      context: context,
      builder: (_) => DeleteDialog(
        titulo: 'Eliminar Receta',
        mensaje: '¿Está seguro de eliminar esta receta?',
        detalles: 'Receta: ${receta.nombre}',
        onConfirmar: () async {
          try {
            await _recetaService.deleteReceta(receta.id);
            if (!mounted) {
              return;
            }
            _loadRecetas(); // Refresh list
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Receta eliminada correctamente'),
                backgroundColor: Colors.red,
              ),
            );
          } catch (e) {
            if (!mounted) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al eliminar receta: $e'),
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
                child: FutureBuilder<List<Receta>>(
                  future: _recetasFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No hay recetas disponibles',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    final recetasFiltradas = _filtrarRecetas(snapshot.data!);

                    if (recetasFiltradas.isEmpty) {
                      return Center(
                        child: Text(
                          'No se encontraron recetas',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: recetasFiltradas.length,
                      itemBuilder: (context, index) {
                        final receta = recetasFiltradas[index];
                        final esSeleccionada =
                            recetaSeleccionada?.id == receta.id;

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          color: esSeleccionada
                              ? Colors.blue[50]
                              : Colors.white,
                          child: ListTile(
                            selected: esSeleccionada,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => RecetaDetailDialog(
                                  receta: receta,
                                  onEditar: (r) => _accionEditar(r),
                                  onEliminar: (r) => _accionEliminar(r),
                                ),
                              );
                            },
                            leading: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.deepOrange,
                                  width: 3,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: receta.imagenReferencial != null
                                    ? (receta.imagenReferencial!.startsWith(
                                            'http',
                                          ))
                                          ? Image.network(
                                              receta.imagenReferencial!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Icon(
                                                    Icons.broken_image,
                                                    size: 30,
                                                    color: Colors.grey,
                                                  ),
                                            )
                                          : Image.file(
                                              File(receta.imagenReferencial!),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                      size: 30,
                                                    );
                                                  },
                                            )
                                    : Icon(
                                        Icons.palette,
                                        color: Colors.deepOrange,
                                        size: 30,
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
                                  overflow: TextOverflow.ellipsis,
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
