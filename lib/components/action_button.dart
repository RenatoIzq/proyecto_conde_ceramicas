import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2, //pequeña sombra
      ), 
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              text,
              style: GoogleFonts.oswald(
                fontSize: 16,
                color: Colors.black
              ),
            ),
          ),
        ],
      ),
    );
  }
}
