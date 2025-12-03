class RecetaMateriaPrima {
  final String? id;
  final String inventarioId;
  final String nombre; // For display purposes, fetched from Inventario
  final double proporcion;

  RecetaMateriaPrima({
    this.id,
    required this.inventarioId,
    required this.nombre,
    required this.proporcion,
  });

  RecetaMateriaPrima copyWith({
    String? id,
    String? inventarioId,
    String? nombre,
    double? proporcion,
  }) {
    return RecetaMateriaPrima(
      id: id ?? this.id,
      inventarioId: inventarioId ?? this.inventarioId,
      nombre: nombre ?? this.nombre,
      proporcion: proporcion ?? this.proporcion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id, // Usually we don't send ID on create, handled by DB or parent
      'inventario_id': inventarioId,
      'proporcion': proporcion,
    };
  }

  factory RecetaMateriaPrima.fromMap(Map<String, dynamic> map) {
    // Handle the nested join structure from Supabase
    // map might look like: { 'proporcion': 10, 'inventario': { 'nombre': 'Arcilla' }, 'inventario_id': '...' }

    String nombre = '';
    if (map['inventario'] != null && map['inventario'] is Map) {
      nombre = map['inventario']['nombre'] ?? '';
    } else if (map['nombre'] != null) {
      nombre = map['nombre'];
    }

    return RecetaMateriaPrima(
      id: map['id']?.toString(),
      inventarioId: map['inventario_id'] ?? '',
      nombre: nombre,
      proporcion: (map['proporcion'] ?? 0).toDouble(),
    );
  }
}

class Receta {
  final String id;
  final String nombre;
  final String descripcion;
  final List<RecetaMateriaPrima> materiaPrima;
  final String? imagenReferencial;

  Receta({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.materiaPrima,
    this.imagenReferencial,
  });

  Receta copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    List<RecetaMateriaPrima>? materiaPrima,
    String? imagenReferencial,
  }) {
    return Receta(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      materiaPrima: materiaPrima ?? this.materiaPrima,
      imagenReferencial: imagenReferencial ?? this.imagenReferencial,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen_referencial': imagenReferencial,
      // materiaPrima is handled separately in the service for Many-to-Many inserts
    };
  }

  factory Receta.fromMap(Map<String, dynamic> map) {
    return Receta(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      materiaPrima: List<RecetaMateriaPrima>.from(
        (map['receta_materia_prima'] as List<dynamic>? ?? [])
            .map<RecetaMateriaPrima>(
              (x) => RecetaMateriaPrima.fromMap(x as Map<String, dynamic>),
            ),
      ),
      imagenReferencial: map['imagen_referencial'], // Note snake_case from DB
    );
  }
}
