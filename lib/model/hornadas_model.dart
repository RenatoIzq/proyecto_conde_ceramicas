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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fechaPlanificada': fechaPlanificada.toIso8601String(),
      'horaInicio': horaInicio?.toIso8601String(),
      'horaInicioReal': horaInicioReal?.toIso8601String(),
      'horaFin': horaFin?.toIso8601String(),
      'perfilTemperatura': perfilTemperatura,
      'estado': estado,
      'horno': horno,
      'observaciones': observaciones,
    };
  }

  factory Hornada.fromJson(Map<String, dynamic> json) {
    return Hornada(
      id: json['id'],
      fechaPlanificada: DateTime.parse(json['fechaPlanificada']),
      horaInicio: json['horaInicio'] != null
          ? DateTime.parse(json['horaInicio'])
          : null,
      horaInicioReal: json['horaInicioReal'] != null
          ? DateTime.parse(json['horaInicioReal'])
          : null,
      horaFin: json['horaFin'] != null ? DateTime.parse(json['horaFin']) : null,
      perfilTemperatura: json['perfilTemperatura'],
      estado: json['estado'],
      horno: json['horno'],
      observaciones: json['observaciones'],
    );
  }
}
