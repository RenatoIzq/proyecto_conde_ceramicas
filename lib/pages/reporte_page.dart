import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/components/report_section.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';
import 'package:proyecto_conde_ceramicas/model/inventario_model.dart';
import 'package:proyecto_conde_ceramicas/services/inventario_service.dart';

class ReportePage extends StatefulWidget {
  const ReportePage({super.key});

  @override
  State<ReportePage> createState() => _ReportePageState();
}

class _ReportePageState extends State<ReportePage> {
  final InventarioService _inventarioService = InventarioService();

  // Filtra esmaltes con stock bajo o agotado
  List<Map<String, dynamic>> _obtenerEsmaltesConStockBajo(
    List<InventarioItem> inventarioItems,
  ) {
    return inventarioItems
        .where(
          (item) =>
              item.tipo == 'Esmalte' &&
              (item.estadoStock == EstadoStock.bajo ||
                  item.estadoStock == EstadoStock.agotado),
        )
        .map(
          (item) => {
            'id': item.codigo,
            'nombre': item.nombre,
            'stock': '${item.stockActual} ${item.unidad}',
            'estado': item.estadoStock == EstadoStock.agotado
                ? 'agotado'
                : 'bajo',
          },
        )
        .toList();
  }

  // Filtra materias primas con stock bajo o agotado
  List<Map<String, dynamic>> _obtenerMateriasPrimasConStockBajo(
    List<InventarioItem> inventarioItems,
  ) {
    return inventarioItems
        .where(
          (item) =>
              item.tipo == 'Materia Prima' &&
              (item.estadoStock == EstadoStock.bajo ||
                  item.estadoStock == EstadoStock.agotado),
        )
        .map(
          (item) => {
            'id': item.codigo,
            'nombre': item.nombre,
            'stock': '${item.stockActual} ${item.unidad}',
            'estado': item.estadoStock == EstadoStock.agotado
                ? 'agotado'
                : 'bajo',
          },
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> headers = ['ID', 'Nombre', 'Stock'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: grisoscuro,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Reporte',
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
        child: StreamBuilder<List<InventarioItem>>(
          stream: _inventarioService.getInventario(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final inventarioItems = snapshot.data ?? [];
            final esmaltesData = _obtenerEsmaltesConStockBajo(inventarioItems);
            final materiasPrimasData = _obtenerMateriasPrimasConStockBajo(
              inventarioItems,
            );

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.top,
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Esmaltes con stock bajo
                      if (esmaltesData.isEmpty)
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Todos los esmaltes tienen stock suficiente',
                                  style: TextStyle(color: Colors.green[800]),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ReportSection(
                          title: 'Esmaltes con Stock Bajo',
                          headers: headers,
                          data: esmaltesData,
                        ),
                      SizedBox(height: 25),

                      // Materias primas con stock bajo
                      if (materiasPrimasData.isEmpty)
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Todas las materias primas tienen stock suficiente',
                                  style: TextStyle(color: Colors.green[800]),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ReportSection(
                          title: 'Materias Primas con Stock Bajo',
                          headers: headers,
                          data: materiasPrimasData,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
