import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/pages/inventario_page.dart';
import 'package:proyecto_conde_ceramicas/pages/reporte_page.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';
import 'package:proyecto_conde_ceramicas/components/menu_button.dart';

class BienvenidaPage extends StatelessWidget {
  const BienvenidaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'images/condeceramicalogo.png',
                  width: 250,
                  height: 250,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Bienvenido, seleccione una opción:',
                textAlign: TextAlign.center,
                style: GoogleFonts.oswald(fontSize: 30, color: Colors.black),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: grisoscuro,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: [
                        MenuButton(
                          title: 'Inventario',
                          icon: Icons.inventory,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InventarioPage(),
                              ),
                            );
                          },
                        ),
                        MenuButton(
                          title: 'Reportes',
                          icon: Icons.report,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportePage(),
                              ),
                            );
                          },
                        ),
                        MenuButton(
                          title: 'Recetario',
                          icon: Icons.menu_book_rounded,
                          onTap: () {
                            Navigator.pushNamed(context, 'recetario');
                          },
                        ),
                        MenuButton(
                          title: 'Horandas',
                          icon: Icons.fireplace,
                          onTap: () {
                            Navigator.pushNamed(context, 'hornadas');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
