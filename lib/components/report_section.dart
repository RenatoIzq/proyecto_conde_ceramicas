import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';

class ReportSection extends StatelessWidget {
  final String title;
  final List<String> headers;
  final List<Map<String, String>> data;

  const ReportSection({
    super.key,
    required this.title,
    required this.headers,
    required this.data,
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: grisoscuro,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          child: DataTableTheme(
            data: DataTableThemeData(
              headingRowColor: Material
            ), 
            child: child
          ),
        ),
      ],
    );
  }
}
