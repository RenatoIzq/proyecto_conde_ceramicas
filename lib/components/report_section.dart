import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';

class ReportSection extends StatelessWidget {
  final String title;
  final List<String> headers;
  final List<Map<String, String>> data;
  final double tableHeight;

  const ReportSection({
    super.key,
    required this.title,
    required this.headers,
    required this.data,
    this.tableHeight = 250.0,
  });

  @override
  Widget build(BuildContext context) {
    //usar theme quizas
    final Color headingColor = Colors.grey[300]!;
    final Color rowColor = Colors.grey[100]!;
    final Color borderColor = Colors.grey[400]!;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: grisoscuro,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5)
          ),
          child: SizedBox(
            height: tableHeight,
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTableTheme(
                data: DataTableThemeData(
                  headingRowColor: WidgetStateColor.resolveWith(
                    (states) => headingColor,
                  ),
                  dataRowColor: WidgetStateColor.resolveWith((states) => rowColor),
                  dividerThickness: 1,
                ),
                child: DataTable(
                  border: TableBorder.all(
                    color: borderColor,
                    width: 1,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  columnSpacing: 10,
                  columns: headers.map((header) => DataColumn(
                    label: Expanded(
                      child: Text(
                        header,
                        style: GoogleFonts.oswald(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),).toList(),
                  rows: data.map((row) => DataRow(
                    cells: headers.map((header) {
                      final cellValue = row[header.toLowerCase()] ?? 'N/A';
                        return DataCell(
                          Center(
                            child: Text(
                              cellValue,
                              style: GoogleFonts.oswald(color: Colors.black),
                            ),
                          ),
                        );
                      }).toList(),
                  ),).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
