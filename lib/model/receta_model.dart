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
}

class Receta {
  final String id;
  final String nombre;
  final String descripcion;
  final List<RecetaMateriaPrima> materiaPrima;

  Receta({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.materiaPrima,
  });

  Receta copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    List<RecetaMateriaPrima>? materiaPrima,
  }) {
    return Receta(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      materiaPrima: materiaPrima ?? this.materiaPrima,
    );
  }
}