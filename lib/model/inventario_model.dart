import 'package:flutter/material.dart';

enum EstadoInventario { disponible, bajo, agotado }

class InventarioItem {
  final String id;
  final String nombre;
  final String codigo;
  final String tipo; // Producto, Materia Prima, Esmalte, Molde
  final int stockInicial;
  final int stockActual;
  final String unidad;
  final EstadoInventario estado;
  final String? imagenReferencial;

  InventarioItem({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.tipo,
    required this.stockInicial,
    required this.stockActual,
    required this.unidad,
    required this.estado,
    this.imagenReferencial,
  });

  // Determina estado automáticamente basado en stock
  static EstadoInventario _determinarEstado(int stockActual, int stockInicial) {
    if (stockActual == 0) return EstadoInventario.agotado;
    if (stockActual < (stockInicial * 0.2)) return EstadoInventario.bajo;
    return EstadoInventario.disponible;
  }

  InventarioItem copyWith({
    String? id,
    String? nombre,
    String? codigo,
    String? tipo,
    int? stockInicial,
    int? stockActual,
    String? unidad,
    EstadoInventario? estado,
    String? imagenReferencial,
  }) {
    final nuevoStock = stockActual ?? this.stockActual;
    final nuevoInicial = stockInicial ?? this.stockInicial;
    return InventarioItem(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      tipo: tipo ?? this.tipo,
      stockInicial: nuevoInicial,
      stockActual: nuevoStock,
      unidad: unidad ?? this.unidad,
      estado: _determinarEstado(nuevoStock, nuevoInicial),
      imagenReferencial: imagenReferencial ?? this.imagenReferencial,
    );
  }

  Color getEstadoColor() {
    switch (estado) {
      case EstadoInventario.disponible:
        return Colors.green;
      case EstadoInventario.bajo:
        return Colors.orange;
      case EstadoInventario.agotado:
        return Colors.red;
    }
  }

  String getEstadoTexto() {
    switch (estado) {
      case EstadoInventario.disponible:
        return 'Disponible';
      case EstadoInventario.bajo:
        return 'Stock Bajo';
      case EstadoInventario.agotado:
        return 'Agotado';
    }
  }
}