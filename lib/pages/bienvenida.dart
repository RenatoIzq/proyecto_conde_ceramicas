import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  width: 200,
                  height: 200,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Bienvenido, seleccione una opción:',
                textAlign: TextAlign.center,
                style: GoogleFonts.oswald(fontSize: 30, color: Colors.white),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
