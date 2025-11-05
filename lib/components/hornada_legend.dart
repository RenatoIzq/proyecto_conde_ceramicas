import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';

class HornadaLegend extends StatelessWidget {
  const HornadaLegend({super.key});

  @override
  Widget build(BuildContext context) {
    Color colorBizcocho = bizcocho; // Verde
    const String textoBizcocho = 'Bizcocho';
    const String tempBizcocho = '950C° - 1050C°';

    Color colorEsmalte = esmalte; // Rojo
    const String textoEsmalte = 'Esmalte';
    const String tempEsmalte = '1200C° - 1300C°';

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leyenda',
            style: GoogleFonts.oswald(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 4),

          _buildLegendItem(colorBizcocho, textoBizcocho, tempBizcocho),

          SizedBox(height: 4),

          _buildLegendItem(colorEsmalte, textoEsmalte, tempEsmalte),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String title, String subtitle) {
    return Row(
      children: [
        Container(width: 20, height: 20, color: color),
        SizedBox(width: 8),
        Text(
          '$title  ', // Título (Bizcocho / Esmalte)
          style: GoogleFonts.oswald(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          subtitle, // Rango de temperatura
          style: GoogleFonts.oswald(fontSize: 16),
        ),
      ],
    );
  }
}
