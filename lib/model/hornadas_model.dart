// lib/models/hornada_model.dart (o al inicio de hornada_page.dart)
import 'package:flutter/material.dart';
import 'package:proyecto_conde_ceramicas/themes/themes.dart';

enum HornadaEstado { programada, enCurso, finalizada }

enum HornadaTipo { bizcocho, esmalte }

class Hornada {
  final String id;
  final DateTime fechaPlanificada;
  final DateTime? horaInicio;
  final DateTime? horaInicioReal;
  final DateTime? horaFin;
  final String perfilTemperatura; // 'Bizcocho' o 'Esmalte'
  final String estado; // 'Planificado', 'En Curso', 'Finalizado'
  final String? horno;
  final String? observaciones; // Temperatura máxima registrada al finalizar

  Hornada({
    required this.id,
    required this.fechaPlanificada,
    this.horaInicio,
    this.horaInicioReal,
    this.horaFin,
    required this.perfilTemperatura,
    required this.estado,
    this.horno,
    this.observaciones,
  });

  // Helper para obtener el color basado en el tipo
  Color get color {
    if (perfilTemperatura == "Bizcocho") {
      return bizcocho;
    }
    return esmalte; // Rojo
  }

  // Helper para obtener el rango de temperatura basado en el tipo
  String get rangoTemperatura {
    if (perfilTemperatura == 'Bizcocho') {
      return '950C° - 1050C°';
    }
    return '1200C° - 1300C°';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha_planificada': fechaPlanificada.toIso8601String(),
      'hora_inicio': horaInicio?.toIso8601String(),
      'hora_inicio_real': horaInicioReal?.toIso8601String(),
      'hora_fin': horaFin?.toIso8601String(),
      'perfil_temperatura': perfilTemperatura,
      'estado': estado,
      'horno': horno,
      'observaciones': observaciones,
    };
  }

  factory Hornada.fromMap(Map<String, dynamic> map) {
    return Hornada(
      id: map['id'] ?? '',
      fechaPlanificada: DateTime.parse(map['fecha_planificada']),
      horaInicio: map['hora_inicio'] != null
          ? DateTime.parse(map['hora_inicio'])
          : null,
      horaInicioReal: map['hora_inicio_real'] != null
          ? DateTime.parse(map['hora_inicio_real'])
          : null,
      horaFin: map['hora_fin'] != null ? DateTime.parse(map['hora_fin']) : null,
      perfilTemperatura: map['perfil_temperatura'] ?? '',
      estado: map['estado'] ?? '',
      horno: map['horno'],
      observaciones: map['observaciones'],
    );
  }
}
