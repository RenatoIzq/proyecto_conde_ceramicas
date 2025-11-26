import 'package:flutter/material.dart';

enum EstadoProducto { crudo, bizcocho, esmaltado, terminado }

enum EstadoStock { disponible, bajo, agotado }

class InventarioItem {
  final String id;
  final String nombre;
  final String codigo;
  final String tipo; // Producto, Materia Prima, Esmalte, Molde
  final int stockInicial;
  final int stockActual;
  final String unidad;
  final EstadoProducto? estadoProducto;
  final EstadoStock? estadoStock;
  final String? imagenReferencial;

  InventarioItem({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.tipo,
    required this.stockInicial,
    required this.stockActual,
    required this.unidad,
    this.estadoProducto,
    this.estadoStock,
    this.imagenReferencial,
  }) : assert(
         // ✅ Validación: Productos deben tener estadoProducto, otros estadoStock
         (tipo == 'Producto' && estadoProducto != null) ||
             (tipo != 'Producto' && estadoStock != null),
         'Estado incorrecto para el tipo de item',
       );

  // Determina estado automáticamente basado en stock
  static EstadoStock determinarEstadoStock(int stockActual, int stockInicial) {
    if (stockActual == 0) return EstadoStock.agotado;
    if (stockActual < (stockInicial * 0.3)) {
      return EstadoStock.bajo;
    } // Umbral del 30%
    return EstadoStock.disponible;
  }

  InventarioItem copyWith({
    String? id,
    String? nombre,
    String? codigo,
    String? tipo,
    int? stockInicial,
    int? stockActual,
    String? unidad,
    EstadoProducto? estadoProducto,
    EstadoStock? estadoStock,
    String? imagenReferencial,
  }) {
    final nuevoStock = stockActual ?? this.stockActual;
    final nuevoInicial = stockInicial ?? this.stockInicial;
    final nuevoTipo = tipo ?? this.tipo;

    return InventarioItem(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      tipo: nuevoTipo,
      stockInicial: nuevoInicial,
      stockActual: nuevoStock,
      unidad: unidad ?? this.unidad,
      estadoProducto: nuevoTipo == 'Producto'
          ? (estadoProducto ?? this.estadoProducto)
          : null,
      estadoStock: nuevoTipo != 'Producto'
          ? determinarEstadoStock(nuevoStock, nuevoInicial)
          : null,
      imagenReferencial: imagenReferencial ?? this.imagenReferencial,
    );
  }

  Color getEstadoColor() {
    if (tipo == 'Producto' && estadoProducto != null) {
      switch (estadoProducto!) {
        case EstadoProducto.crudo:
          return Colors.grey[600]!;
        case EstadoProducto.bizcocho:
          return Colors.green;
        case EstadoProducto.esmaltado:
          return Colors.red;
        case EstadoProducto.terminado:
          return Colors.blue;
      }
    } else if (estadoStock != null) {
      switch (estadoStock!) {
        case EstadoStock.disponible:
          return Colors.green;
        case EstadoStock.bajo:
          return Colors.orange;
        case EstadoStock.agotado:
          return Colors.red;
      }
    }
    return Colors.grey;
  }

  String getEstadoTexto() {
    if (tipo == 'Producto' && estadoProducto != null) {
      switch (estadoProducto!) {
        case EstadoProducto.crudo:
          return 'Crudo';
        case EstadoProducto.bizcocho:
          return 'Bizcocho';
        case EstadoProducto.esmaltado:
          return 'Esmaltado';
        case EstadoProducto.terminado:
          return 'Terminado';
      }
    } else if (estadoStock != null) {
      switch (estadoStock!) {
        case EstadoStock.disponible:
          return 'Disponible';
        case EstadoStock.bajo:
          return 'Stock Bajo';
        case EstadoStock.agotado:
          return 'Agotado';
      }
    }
    return 'Sin estado';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'tipo': tipo,
      'stockInicial': stockInicial,
      'stockActual': stockActual,
      'unidad': unidad,
      'estadoProducto': estadoProducto?.name,
      'estadoStock': estadoStock?.name,
      'imagenReferencial': imagenReferencial,
    };
  }

  factory InventarioItem.fromMap(Map<String, dynamic> map) {
    return InventarioItem(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      codigo: map['codigo'] ?? '',
      tipo: map['tipo'] ?? '',
      stockInicial: map['stockInicial']?.toInt() ?? 0,
      stockActual: map['stockActual']?.toInt() ?? 0,
      unidad: map['unidad'] ?? '',
      estadoProducto: map['estadoProducto'] != null
          ? EstadoProducto.values.firstWhere(
              (e) => e.name == map['estadoProducto'],
              orElse: () => EstadoProducto.crudo, // Default fallback
            )
          : null,
      estadoStock: map['estadoStock'] != null
          ? EstadoStock.values.firstWhere(
              (e) => e.name == map['estadoStock'],
              orElse: () => EstadoStock.disponible, // Default fallback
            )
          : null,
      imagenReferencial: map['imagenReferencial'],
    );
  }
}
