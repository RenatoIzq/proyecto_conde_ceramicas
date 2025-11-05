import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:proyecto_conde_ceramicas/model/hornadas_model.dart';

class CalendarioHornada extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Map<DateTime, List<Hornada>> hornadas;
  final Function(DateTime, DateTime) onDaySelected;

  const CalendarioHornada({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.hornadas,
    required this.onDaySelected,
  });

  DateTime _normalizarFecha(DateTime fecha) {
    return DateTime(fecha.year, fecha.month, fecha.day);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TableCalendar(
        firstDay: DateTime(2024),
        lastDay: DateTime(2030),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        locale: 'es_ES',
        rowHeight: 40,
        daysOfWeekHeight: 20,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
          leftChevronMargin: EdgeInsets.all(0), // ✅ Sin márgenes extra
          rightChevronMargin: EdgeInsets.all(0),
          leftChevronPadding: EdgeInsets.all(4),
          rightChevronPadding: EdgeInsets.all(4),
        ),
        calendarStyle: CalendarStyle(
          cellMargin: EdgeInsets.all(4),
          weekendTextStyle: TextStyle(color: Colors.red),
          todayDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(6),
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(6),
          ),
          defaultTextStyle: TextStyle(color: Colors.black),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle(color: Colors.red),
          weekdayStyle: TextStyle(color: Colors.black),
        ),
        eventLoader: (day) {
          final key = _normalizarFecha(day);
          return hornadas[key] ?? [];
        },
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final key = _normalizarFecha(day);
            final hornadasDelDia = hornadas[key];

            if (hornadasDelDia != null && hornadasDelDia.isNotEmpty) {
              final hornada = hornadasDelDia.first;
              return Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: hornada.color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            return null;
          },
          selectedBuilder: (context, day, focusedDay) {
            final key = _normalizarFecha(day);
            final hornadasDelDia = hornadas[key];

            if (hornadasDelDia != null && hornadasDelDia.isNotEmpty) {
              final hornada = hornadasDelDia.first;
              return Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: hornada.color,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            return null;
          },
          todayBuilder: (context, day, focusedDay) {
            final key = _normalizarFecha(day);
            final hornadasDelDia = hornadas[key];

            if (hornadasDelDia != null && hornadasDelDia.isNotEmpty) {
              final hornada = hornadasDelDia.first;
              return Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: hornada.color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            return null;
          },
        ),
        onDaySelected: onDaySelected,
      ),
    );
  }
}
