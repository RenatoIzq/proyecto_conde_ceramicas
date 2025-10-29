import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/components/search_filter_bar.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';

class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key});

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  String selectedFilter = 'Producto'; // Valor inicial
  final List<String> filterOptions = [
    'Producto',
    'Materia Prima',
    'Esmalte',
    'Molde',
  ];

  final TextEditingController searchController =
      TextEditingController(); // Pública
  String searchTerm = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
          'Inventario',
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SearchFilterBar(
                selectedFilter: selectedFilter,
                filterOptions: filterOptions,
                onFilterChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedFilter = newValue;
                    });
                  }
                },
                searchController: searchController,
                searchHintText: 'Buscar por nombre o código...',
                onSearchChanged: (value) {
                  setState(() {
                    searchTerm = value;
                  });
                },
                onSearchSubmitted: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
