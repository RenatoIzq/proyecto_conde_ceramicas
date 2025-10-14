import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuButton extends StatelessWidget {
  final String title; //Le entrego el texto que va a tener el boton
  final IconData icon; //Le entrego el icono que va a tener el boton
  final VoidCallback onTap; //Le entrego la funcion que va a ejecutar al presionarlo

  const MenuButton({
    super.key,
    required this.title,
    required this.icon, 
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.black),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.oswald(fontSize: 20, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}