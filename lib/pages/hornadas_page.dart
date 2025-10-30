import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/components/action_button.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';

import 'package:proyecto_conde_ceramicas/model/hornadas_model.dart';
import 'package:proyecto_conde_ceramicas/components/hornada_legend.dart';
import 'package:proyecto_conde_ceramicas/components/hornadas_calendar.dart';

class HornadasPage extends StatefulWidget {
  const HornadasPage({super.key});

  @override
  State<HornadasPage> createState() => _HornadasPageState();
}

class _HornadasPageState extends State<HornadasPage> {
  void _accionAnadir() {
    print('Botón Añadir presionado');
    // Aquí iría la lógica para añadir un nuevo item
  }

  void _accionEliminar() {
    print('Botón Eliminar presionado');
    // Aquí iría la lógica para eliminar (necesitarías saber qué item está seleccionado)
  }

  @override
  Widget build(BuildContext context) {
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
          'Hornadas',
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
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ActionButton(
                      text: 'Añadir',
                      onPressed: _accionAnadir,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ActionButton(
                      text: 'Eliminar',
                      onPressed: _accionEliminar,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              const HornadaLegend(),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
