import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';

class ReportePage extends StatelessWidget {
  const ReportePage({super.key});

  @override
  Widget build(BuildContext context) {

    // Datos de ejemplo (reemplazar con datos reales de Firestore/API)
    final List<Map<String, String>> esmaltesData = [
      {'id': 'E001', 'nombre': 'Azul Cobalto', 'stock': '10 L'},
      {'id': 'E002', 'nombre': 'Rojo Intenso', 'stock': '5 L'},
      {'id': 'E003', 'nombre': 'Verde Esmeralda', 'stock': '8 L'},
      // Agrega más filas si es necesario
    ];

    final List<Map<String, String>> materiasPrimasData = [
      {'id': 'MP01', 'nombre': 'Arcilla Blanca', 'stock': '50 Kg'},
      {'id': 'MP02', 'nombre': 'Caolín', 'stock': '25 Kg'},
      {'id': 'MP03', 'nombre': 'Feldespato', 'stock': '30 Kg'},
      {'id': 'MP04', 'nombre': 'Sílice', 'stock': '40 Kg'},
      // Agrega más filas si es necesario
    ];

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
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ReportSec
          ],
        ),
      ),
    );
  }
}