import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';

class SearchFilterBar extends StatelessWidget {
  //Dropdown
  final String selectedFilter;
  final List<String> filterOptions;
  final ValueChanged<String> onFilterChanged;

  //TextField
  final TextEditingController? searchController; // Opcional, para controlar el texto desde fuera
  final ValueChanged<String>? onSearchChanged; // Callback para cuando cambia el texto
  final VoidCallback? onSearchSubmitted; // Callback para cuando se "envía" la búsqueda (ej: Enter)
  final String searchHintText; // Texto de sugerencia para el campo de búsqueda

  const SearchFilterBar({
    super.key,
    required this.selectedFilter,
    required this.filterOptions,  
    required this.onFilterChanged,

    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.searchHintText = 'Buscar...', // Valor por defecto
    });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            onSubmitted: (_) {
              if (onSearchSubmitted != null) {
                onSearchSubmitted!();
              }
            },
            style: GoogleFonts.oswald(
              color: Colors.black,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: searchHintText,
              hintStyle: GoogleFonts.oswald(color: Colors.grey[600]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[400]!)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: grisoscuro)
              ),
            ),
          ),
        ),
        SizedBox(width: 2),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedFilter,
                isExpanded: true,
                dropdownColor: Colors.grey[200],
                style: GoogleFonts.oswald(color: Colors.black, fontSize: 16,),
                iconEnabledColor: Colors.black,
                items: filterOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option, style: GoogleFonts.oswald(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    onFilterChanged(newValue);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}