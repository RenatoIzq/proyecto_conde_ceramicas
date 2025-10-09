import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';

class Bienvenida extends StatelessWidget {
  const Bienvenida({super.key});

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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
