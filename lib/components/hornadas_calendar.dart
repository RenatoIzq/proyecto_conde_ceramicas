import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_conde_ceramicas/model/hornadas_model.dart';
import 'package:table_calendar/table_calendar.dart';

class HornadasCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;
  final Map<DateTime, List<Hornada>> events; // Usa el modelo Hornada
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final Function(DateTime focusedDay) onPageChanged;

  const HornadasCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.events,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  List<Hornada> _getEventsForDay(DateTime day) {
    final dayUtc = DateTime.utc(day.year, day.month, day.day);
    return events[dayUtc] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TableCalendar<Hornada>(
        locale: 'es_ES',
        focusedDay: focusedDay,
        firstDay: DateTime.utc(2022, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        calendarFormat: calendarFormat,
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,

        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.oswald(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(Icons.chevron_left_rounded),
          rightChevronIcon: Icon(Icons.chevron_right_rounded),
        ),

        calendarStyle: CalendarStyle(
          weekendTextStyle: TextStyle(color: Colors.red[800]),
          selectedDecoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(color: Colors.black),
          todayDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          markersAlignment: Alignment.bottomCenter,
          markerDecoration: BoxDecoration(
            color: Colors.blueGrey,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 3,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, hornadasDelDia) {
            if (hornadasDelDia.isNotEmpty) {
              return Positioned(
                right: 1,
                bottom: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: hornadasDelDia.take(3).map((hornada) {
                    return Container(
                      width: 7,
                      height: 7,
                      margin: EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hornada.color,
                      ),
                    );
                  }).toList(),
                ),
              );
            }
            return null;
          },
        ),
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        onFormatChanged: (format) {},
      ),
    );
  }
}
