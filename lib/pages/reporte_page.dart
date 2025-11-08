import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/components/report_section.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';
import 'package:proyecto_conde_ceramicas/model/inventario_model.dart';

class ReportePage extends StatelessWidget {
  const ReportePage({super.key});

  // ✅ Genera datos de prueba internos
  List<InventarioItem> _obtenerDatos() {
    return [
      // Esmaltes con stock bajo
      InventarioItem(
        id: '1',
        nombre: 'Esmalte Azul',
        codigo: 'ESM-001',
        tipo: 'Esmalte',
        stockInicial: 100,
        stockActual: 5,
        unidad: 'L',
        estadoStock: EstadoStock.bajo,
      ),
      InventarioItem(
        id: '2',
        nombre: 'Esmalte Verde',
        codigo: 'ESM-002',
        tipo: 'Esmalte',
        stockInicial: 80,
        stockActual: 0,
        unidad: 'L',
        estadoStock: EstadoStock.agotado,
      ),
      InventarioItem(
        id: '3',
        nombre: 'Esmalte Rojo',
        codigo: 'ESM-003',
        tipo: 'Esmalte',
        stockInicial: 120,
        stockActual: 100,
        unidad: 'L',
        estadoStock: EstadoStock.disponible,
      ),

      // Materias Primas con stock bajo
      InventarioItem(
        id: '4',
        nombre: 'Arcilla Blanca',
        codigo: 'ARC-001',
        tipo: 'Materia Prima',
        stockInicial: 500,
        stockActual: 50,
        unidad: 'kg',
        estadoStock: EstadoStock.bajo,
      ),
      InventarioItem(
        id: '5',
        nombre: 'Arcilla Roja',
        codigo: 'ARC-002',
        tipo: 'Materia Prima',
        stockInicial: 300,
        stockActual: 0,
        unidad: 'kg',
        estadoStock: EstadoStock.agotado,
      ),
      InventarioItem(
        id: '6',
        nombre: 'Caolín',
        codigo: 'ARC-003',
        tipo: 'Materia Prima',
        stockInicial: 200,
        stockActual: 180,
        unidad: 'kg',
        estadoStock: EstadoStock.disponible,
      ),
      InventarioItem(
        id: '7',
        nombre: 'Feldespato',
        codigo: 'MAT-001',
        tipo: 'Materia Prima',
        stockInicial: 150,
        stockActual: 10,
        unidad: 'kg',
        estadoStock: EstadoStock.bajo,
      ),
      InventarioItem(
        id: '8',
        nombre: 'Sílice',
        codigo: 'MAT-002',
        tipo: 'Materia Prima',
        stockInicial: 100,
        stockActual: 0,
        unidad: 'kg',
        estadoStock: EstadoStock.agotado,
      ),

      // Otros tipos (no aparecerán en el reporte)
      InventarioItem(
        id: '9',
        nombre: 'Plato Decorativo',
        codigo: 'PROD-001',
        tipo: 'Producto',
        stockInicial: 100,
        stockActual: 85,
        unidad: 'piezas',
        estadoProducto: EstadoProducto.terminado,
      ),
      InventarioItem(
        id: '10',
        nombre: 'Molde Cilindro',
        codigo: 'MOL-001',
        tipo: 'Molde',
        stockInicial: 20,
        stockActual: 18,
        unidad: 'piezas',
        estadoStock: EstadoStock.disponible,
      ),
    ];
  }

  // ✅ Filtra esmaltes con stock bajo o agotado
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
                : 'bajo', // ✅ NUEVO
          },
        )
        .toList();
  }

  // ✅ Filtra materias primas con stock bajo o agotado
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
                : 'bajo', // ✅ NUEVO
          },
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Obtiene los datos de prueba
    final inventarioItems = _obtenerDatos();
    final esmaltesData = _obtenerEsmaltesConStockBajo(inventarioItems);
    final materiasPrimasData = _obtenerMateriasPrimasConStockBajo(
      inventarioItems,
    );
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
        child: SingleChildScrollView(
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
                  // ✅ Esmaltes con stock bajo
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

                  // ✅ Materias primas con stock bajo
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
        ),
      ),
    );
  }
}
