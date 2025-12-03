import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';

import 'package:proyecto_conde_ceramicas/model/hornadas_model.dart';
import 'package:proyecto_conde_ceramicas/services/hornada_service.dart';
import 'package:proyecto_conde_ceramicas/components/hornada_legend.dart';
import 'package:proyecto_conde_ceramicas/components/hornadas_calendar.dart';
import 'package:proyecto_conde_ceramicas/components/hornada_planning_section.dart';
import 'package:proyecto_conde_ceramicas/dialogs/finalizer_dialog.dart';
import 'package:proyecto_conde_ceramicas/dialogs/planifier_dialog.dart';
import 'package:proyecto_conde_ceramicas/dialogs/register_dialog.dart';

class HornadasPage extends StatefulWidget {
  const HornadasPage({super.key});

  @override
  State<HornadasPage> createState() => _HornadasPageState();
}

class _HornadasPageState extends State<HornadasPage> {
  final HornadaService _hornadaService = HornadaService();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  late Stream<List<Hornada>> _hornadasStream;

  @override
  void initState() {
    super.initState();
    _hornadasStream = _hornadaService.getHornadas();
    _selectedDay = _normalizarFecha(DateTime.now());
  }

  DateTime _normalizarFecha(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }

  Map<DateTime, List<Hornada>> _agruparHornadasPorFecha(
    List<Hornada> hornadas,
  ) {
    final Map<DateTime, List<Hornada>> map = {};
    for (var hornada in hornadas) {
      final fecha = _normalizarFecha(hornada.fechaPlanificada);
      if (map[fecha] == null) {
        map[fecha] = [];
      }
      map[fecha]!.add(hornada);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: grisoscuro,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Hornadas',
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
        child: StreamBuilder<List<Hornada>>(
          stream: _hornadasStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final hornadasList = snapshot.data ?? [];
            final hornadasMap = _agruparHornadasPorFecha(hornadasList);

            return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  CalendarioHornada(
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    hornadas: hornadasMap,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      _manejarSeleccionDia(selectedDay, hornadasMap);
                    },
                  ),
                  SizedBox(height: 1),
                  const HornadaLegend(),
                  SizedBox(height: 1),
                  Expanded(
                    child: ListaPlanificaciones(
                      hornadas: hornadasMap,
                      onHornadaTap: (hornada) {
                        setState(() => _selectedDay = hornada.fechaPlanificada);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _manejarSeleccionDia(
    DateTime dia,
    Map<DateTime, List<Hornada>> hornadasMap,
  ) {
    final key = _normalizarFecha(dia);
    final hornadasDelDia = hornadasMap[key];

    if (hornadasDelDia == null || hornadasDelDia.isEmpty) {
      // Día SIN pintar: mostrar diálogo de planificación
      showDialog(
        context: context,
        builder: (_) => PlanifierDialog(
          fechaSeleccionada: dia,
          onPlanificar: _agregarHornada,
        ),
      );
    } else {
      final hornada = hornadasDelDia.first;

      if (hornada.estado == 'Planificado') {
        // Día CON planificación: mostrar diálogo de registro
        showDialog(
          context: context,
          builder: (_) => RegisterDialog(
            hornada: hornada,
            onRegistrar: _actualizarHornada,
            onEliminar: _eliminarHornada,
          ),
        );
      } else if (hornada.estado == 'En Curso') {
        // Día EN CURSO: mostrar diálogo para finalizar
        showDialog(
          context: context,
          builder: (_) => FinalizerDialog(
            hornada: hornada,
            onFinalizar: _actualizarHornada,
          ),
        );
      } else {
        // Hornada finalizada: mostrar información
        _mostrarInfoHornada(hornada);
      }
    }
  }

  void _mostrarInfoHornada(Hornada hornada) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Información de Hornada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estado: ${hornada.estado}'),
            SizedBox(height: 8),
            Text('Perfil: ${hornada.perfilTemperatura}'),
            Text('Horno: ${hornada.horno ?? '--'}'),
            if (hornada.horaInicio != null)
              Text(
                'Hora Inicio: ${TimeOfDay.fromDateTime(hornada.horaInicio!).format(context)}',
              ),
            if (hornada.horaInicioReal != null)
              Text(
                'Hora Inicio Real: ${TimeOfDay.fromDateTime(hornada.horaInicioReal!).format(context)}',
              ),
            if (hornada.horaFin != null)
              Text(
                'Hora Fin: ${TimeOfDay.fromDateTime(hornada.horaFin!).format(context)}',
              ),
            if (hornada.observaciones != null) ...[
              SizedBox(height: 8),
              Text('Observaciones:'),
              Text(
                hornada.observaciones!,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _refreshHornadas() {
    setState(() {
      _hornadasStream = _hornadaService.getHornadas();
    });
  }

  Future<void> _agregarHornada(Hornada hornada) async {
    try {
      await _hornadaService.addHornada(hornada);
      _refreshHornadas();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hornada planificada correctamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al planificar hornada: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _actualizarHornada(Hornada hornada) async {
    try {
      await _hornadaService.updateHornada(hornada);
      _refreshHornadas();
      if (!mounted) return;
      String mensaje = hornada.estado == 'En Curso'
          ? 'Quema iniciada correctamente'
          : 'Quema finalizada correctamente';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar hornada: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _eliminarHornada(Hornada hornada) async {
    try {
      await _hornadaService.deleteHornada(hornada.id);
      _refreshHornadas();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Planificación eliminada'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar hornada: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
