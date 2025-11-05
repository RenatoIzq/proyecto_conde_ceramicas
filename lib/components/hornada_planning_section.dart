import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_conde_ceramicas/model/hornadas_model.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';

class ListaPlanificaciones extends StatelessWidget {
  final Map<DateTime, List<Hornada>> hornadas;
  final Function(Hornada)? onHornadaTap;

  const ListaPlanificaciones({
    super.key,
    required this.hornadas,
    this.onHornadaTap,
  });

  @override
  Widget build(BuildContext context) {
    final todasHornadas = hornadas.values.expand((list) => list).toList();
    todasHornadas.sort(
      (a, b) => a.fechaPlanificada.compareTo(b.fechaPlanificada),
    );

    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: grisoscuro,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Planificación',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: todasHornadas.isEmpty
                ? Center(
                    child: Text(
                      'No hay planificaciones',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: todasHornadas.length,
                    itemBuilder: (context, index) {
                      final hornada = todasHornadas[index];
                      return _buildItemPlanificacion(hornada);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemPlanificacion(Hornada hornada) {
    return InkWell(
      onTap: onHornadaTap != null ? () => onHornadaTap!(hornada) : null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFF505050),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat(
                'EEEE dd \'de\' MMMM \'de\' yyyy',
                'es_ES',
              ).format(hornada.fechaPlanificada),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: hornada.color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Tipo: ${hornada.perfilTemperatura}',
                  style: TextStyle(color: Colors.white70),
                ),
                Spacer(),
                Text(
                  'Estado: ${hornada.estado}',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            if (hornada.horno != null) ...[
              SizedBox(height: 4),
              Text(
                'Horno: ${hornada.horno}',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
