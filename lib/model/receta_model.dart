class RecetaMateriaPrima {
  final String id;
  final String nombre;
  final double proporcion;

  RecetaMateriaPrima({
    required this.id,
    required this.nombre,
    required this.proporcion,
  });

  RecetaMateriaPrima copyWith({
    String? id,
    String? nombre,
    double? proporcion,
  }) {
    return RecetaMateriaPrima(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      proporcion: proporcion ?? this.proporcion,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre, 'proporcion': proporcion};
  }

  factory RecetaMateriaPrima.fromMap(Map<String, dynamic> map) {
    return RecetaMateriaPrima(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
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
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'materiaPrima': materiaPrima.map((x) => x.toMap()).toList(),
      'imagenReferencial': imagenReferencial,
    };
  }

  factory Receta.fromMap(Map<String, dynamic> map) {
    return Receta(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      materiaPrima: List<RecetaMateriaPrima>.from(
        (map['materiaPrima'] as List<dynamic>? ?? []).map<RecetaMateriaPrima>(
          (x) => RecetaMateriaPrima.fromMap(x as Map<String, dynamic>),
        ),
      ),
      imagenReferencial: map['imagenReferencial'],
    );
  }
}
