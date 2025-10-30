//ARREGLAR

// lib/components/hornada_planning_section.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_conde_ceramicas/model/hornadas_model.dart';

class HornadaPlanningSection extends StatelessWidget {
  // Recibe la lista COMPLETA de hornadas
  final List<Hornada> allHornadas;

  const HornadaPlanningSection({
    super.key,
    required this.allHornadas,
    // ¡Ya no necesita callbacks de botones!
  });

  // Función interna para preparar los datos
  Map<DateTime, List<Hornada>> _getGroupedHornadas() {
    // 1. Filtrar solo las que no están 'Finalizada'
    final filtered = allHornadas
        .where(
          (h) =>
              h.estado == HornadaEstado.Programada ||
              h.estado == HornadaEstado.EnCurso,
        )
        .toList();

    // 2. Ordenar por fecha y luego por hora
    filtered.sort((a, b) {
      int dateComp = a.fechaProgramada.compareTo(b.fechaProgramada);
      if (dateComp != 0) return dateComp;
      // Si es la misma fecha, ordenar por hora
      final aTime = DateTime(
        0,
        0,
        0,
        a.horaProgramada.hour,
        a.horaProgramada.minute,
      );
      final bTime = DateTime(
        0,
        0,
        0,
        b.horaProgramada.hour,
        b.horaProgramada.minute,
      );
      return aTime.compareTo(bTime);
    });

    // 3. Agrupar por fecha
    Map<DateTime, List<Hornada>> grouped = {};
    for (var hornada in filtered) {
      final dateKey =
          hornada.fechaProgramadaUtc; // Usamos la fecha UTC como clave
      if (grouped[dateKey] == null) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(hornada);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos las hornadas filtradas y agrupadas
    final groupedHornadas = _getGroupedHornadas();
    // Creamos una lista de las fechas (claves del mapa)
    final dateKeys = groupedHornadas.keys.toList();
    final DateFormat formatter = DateFormat(
      'EEEE dd \'de\' MMMM \'de\' yyyy',
      'es_ES',
    );

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        // Usamos ClipRRect para que la cabecera respete los bordes redondeados
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Cabecera Fija (como en tu imagen) ---
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                color: Colors.grey[800], // Color oscuro para la cabecera
                child: Text(
                  'Planificación',
                  style: GoogleFonts.oswald(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // --- 2. Lista Scrollable ---
              Expanded(
                child: groupedHornadas.isEmpty
                    ? Center(
                        child: Text(
                          'No hay hornadas programadas o en curso.',
                          style: GoogleFonts.oswald(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero, // Sin padding
                        itemCount: dateKeys.length, // Un item por CADA FECHA
                        itemBuilder: (context, index) {
                          DateTime date = dateKeys[index];
                          List<Hornada> hornadasDelDia = groupedHornadas[date]!;

                          // Construye el grupo para esa fecha
                          return _buildDateGroup(
                            context,
                            formatter.format(date).capitalizeFirst(),
                            hornadasDelDia,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget para el grupo de fecha (Jueves 09...) ---
  Widget _buildDateGroup(
    BuildContext context,
    String title,
    List<Hornada> hornadas,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabecera de la Fecha
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          color: Colors.grey[300], // Fondo gris para el día
          child: Text(
            title,
            style: GoogleFonts.oswald(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Items de esa fecha (Bizcocho, Esmalte, etc.)
        Column(
          children: hornadas
              .map((hornada) => _buildPlanningItem(context, hornada))
              .toList(),
        ),
      ],
    );
  }

  // --- Widget para el item individual (Tipo: Bizcocho...) ---
  Widget _buildPlanningItem(BuildContext context, Hornada hornada) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Columna de Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tipo: ${hornada.tipo == HornadaTipo.Bizcocho ? "Bizcocho" : "Esmalte"}',
                style: GoogleFonts.oswald(fontSize: 14),
              ),
              Text(
                'Hora Inicio: ${hornada.horaProgramadaString}',
                style: GoogleFonts.oswald(fontSize: 14),
              ),
            ],
          ),
          // Columna de Estado
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Estado: ${hornada.estadoString}',
                style: GoogleFonts.oswald(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  // Color especial si está "En Curso"
                  color: hornada.estado == HornadaEstado.EnCurso
                      ? Colors.blue[800]
                      : Colors.black87,
                ),
              ),
              Text(
                hornada.horno,
                style: GoogleFonts.oswald(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
