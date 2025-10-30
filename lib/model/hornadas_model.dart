// lib/models/hornada_model.dart (o al inicio de hornada_page.dart)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';

enum HornadaEstado { Programada, EnCurso, Finalizada }

enum HornadaTipo { Bizcocho, Esmalte }

class Hornada {
  final String id; // Identificador único
  HornadaTipo tipo;
  DateTime fechaProgramada;
  TimeOfDay horaProgramada;
  String horno; // Identificador del horno
  String perfilTemperatura; // Nombre o descripción del perfil
  HornadaEstado estado;

  DateTime? horaInicioReal;
  DateTime? horaFinEsperada;

  DateTime? horaFinReal;
  double? temperaturaMaxima; // Temperatura máxima registrada al finalizar

  Hornada({
    required this.id,
    required this.tipo,
    required this.fechaProgramada,
    required this.horaProgramada,
    required this.horno,
    required this.perfilTemperatura,
    this.estado = HornadaEstado.Programada,
    this.horaInicioReal,
    this.horaFinEsperada,
    this.horaFinReal,
    this.temperaturaMaxima,
  });

  // Helper para obtener el color basado en el tipo
  Color get color {
    if (tipo == HornadaTipo.Bizcocho) {
      return bizcocho;
    }
    return esmalte; // Rojo
  }

  // Helper para obtener el rango de temperatura basado en el tipo
  String get rangoTemperatura {
    if (tipo == HornadaTipo.Bizcocho) {
      return '950C° - 1050C°';
    }
    return '1200C° - 1300C°';
  }

  // Helper para convertir TimeOfDay a String HH:mm
  String get horaProgramadaString {
    final now = DateTime.now();
    final dt = DateTime(
      now.year,
      now.month,
      now.day,
      horaProgramada.hour,
      horaProgramada.minute,
    );
    return DateFormat('HH:mm', 'es_ES').format(dt);
  }

  // Helper para mostrar el estado como texto
  String get estadoString {
    switch (estado) {
      case HornadaEstado.Programada:
        return 'Programada';
      case HornadaEstado.EnCurso:
        return 'En Curso';
      case HornadaEstado.Finalizada:
        return 'Finalizada';
    }
  }

  DateTime get fechaProgramadaUtc {
    return DateTime.utc(
      fechaProgramada.year,
      fechaProgramada.month,
      fechaProgramada.day,
    );
  }
}

extension StringExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
