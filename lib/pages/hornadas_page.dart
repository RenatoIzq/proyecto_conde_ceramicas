import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';

import 'package:proyecto_conde_ceramicas/model/hornadas_model.dart';
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
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Hornada>> _hornadas = {};

  @override
  void initState() {
    super.initState();
    _cargarDatosDePrueba();
  }

  DateTime _normalizarFecha(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }

  // Cargar datos de prueba (simulando base de datos)
  void _cargarDatosDePrueba() {
    // Puedes agregar algunos datos de ejemplo aquí
    final hoy = DateTime.now();
    final manana = hoy.add(Duration(days: 1));
    final pasado = hoy.subtract(Duration(days: 3));

    // Ejemplo de hornada planificada
    final hornadaPlanificada = Hornada(
      id: '1',
      fechaPlanificada: manana,
      horaInicio: DateTime(manana.year, manana.month, manana.day, 8, 0),
      perfilTemperatura: 'Bizcocho',
      estado: 'Planificado',
      horno: 'Horno 1',
      observaciones: 'Quema de prueba',
    );

    // Ejemplo de hornada en curso
    final hornadaEnCurso = Hornada(
      id: '2',
      fechaPlanificada: hoy,
      horaInicio: DateTime(hoy.year, hoy.month, hoy.day, 7, 0),
      horaInicioReal: DateTime(hoy.year, hoy.month, hoy.day, 7, 15),
      perfilTemperatura: 'Esmalte',
      estado: 'En Curso',
      horno: 'Horno 2',
    );

    // Ejemplo de hornada finalizada
    final hornadaFinalizada = Hornada(
      id: '3',
      fechaPlanificada: pasado,
      horaInicio: DateTime(pasado.year, pasado.month, pasado.day, 8, 0),
      horaInicioReal: DateTime(pasado.year, pasado.month, pasado.day, 8, 10),
      horaFin: DateTime(pasado.year, pasado.month, pasado.day, 16, 30),
      perfilTemperatura: 'Bizcocho',
      estado: 'Finalizado',
      horno: 'Horno 1',
    );

    setState(() {
      _hornadas[_normalizarFecha(manana)] = [hornadaPlanificada];
      _hornadas[_normalizarFecha(hoy)] = [hornadaEnCurso];
      _hornadas[_normalizarFecha(pasado)] = [hornadaFinalizada];
    });
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
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CalendarioHornada(
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                hornadas: _hornadas,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _manejarSeleccionDia(selectedDay);
                },
              ),
              SizedBox(height: 5),
              const HornadaLegend(),
              SizedBox(height: 5),
              Expanded(
                child: ListaPlanificaciones(
                  hornadas: _hornadas,
                  onHornadaTap: (hornada) {
                    // Opcional: manejar tap en item de lista
                    setState(() => _selectedDay = hornada.fechaPlanificada);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _manejarSeleccionDia(DateTime dia) {
    final key = _normalizarFecha(dia);
    final hornadasDelDia = _hornadas[key];

    if (hornadasDelDia == null || hornadasDelDia.isEmpty) {
      // Día SIN pintar: mostrar diálogo de planificación
      showDialog(
        context: context,
        builder: (context) => PlanifierDialog(
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
          builder: (context) => RegisterDialog(
            hornada: hornada,
            onRegistrar: _actualizarHornada,
            onEliminar: _eliminarHornada,
          ),
        );
      } else if (hornada.estado == 'En Curso') {
        // Día EN CURSO: mostrar diálogo para finalizar
        showDialog(
          context: context,
          builder: (context) => FinalizerDialog(
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

  void _agregarHornada(Hornada hornada) {
    setState(() {
      final key = _normalizarFecha(hornada.fechaPlanificada);
      _hornadas[key] = [hornada];
    });

    // Simulando guardado
    print('Hornada agregada: ${hornada.id}');

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hornada planificada correctamente'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _actualizarHornada(Hornada hornada) {
    setState(() {
      final key = _normalizarFecha(hornada.fechaPlanificada);
      _hornadas[key] = [hornada];
    });

    // Simulando actualización
    print('Hornada actualizada: ${hornada.id} - Estado: ${hornada.estado}');

    // Mostrar confirmación
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
  }

  void _eliminarHornada(Hornada hornada) {
    setState(() {
      final key = _normalizarFecha(hornada.fechaPlanificada);
      _hornadas.remove(key);
    });

    // Simulando eliminación
    print('Hornada eliminada: ${hornada.id}');

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Planificación eliminada'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
