import 'dart:math';
import 'package:proyecto_conde_ceramicas/model/inventario_model.dart';
import 'package:proyecto_conde_ceramicas/model/receta_model.dart';
import 'package:proyecto_conde_ceramicas/model/hornadas_model.dart';
import 'package:proyecto_conde_ceramicas/services/inventario_service.dart';
import 'package:proyecto_conde_ceramicas/services/receta_service.dart';
import 'package:proyecto_conde_ceramicas/services/hornada_service.dart';

// =======================================================
// 1. SEEDING PARA INVENTARIO (3 por Tipo/Categoría)
// =======================================================
Future<void> seedInventario() async {
  final inventarioService = InventarioService();

  // Las 4 categorías definidas en su prompt y modelo
  final tipos = ['Producto', 'Materia Prima', 'Esmalte', 'Molde'];

  print('🌱 Iniciando Seed para Inventario...');

  for (final tipo in tipos) {
    // Crear 3 ítems por cada tipo
    for (int i = 1; i <= 3; i++) {
      // Configuración dinámica según el tipo para cumplir los asserts del modelo
      EstadoProducto? estProducto;
      EstadoStock? estStock;
      String? unidad;
      String nombreItem = '$tipo de Prueba $i';

      if (tipo == 'Producto') {
        // Los productos REQUIEREN estadoProducto
        // Rotamos los estados: crudo, bizcocho, esmaltado...
        estProducto = EstadoProducto.values[i % EstadoProducto.values.length];
        estStock =
            null; // Productos no usan estadoStock directamente en este modelo
        unidad = 'Unidad';
      } else {
        // Materia Prima, Esmalte, Molde REQUIEREN estadoStock
        estProducto = null;
        estStock = EstadoStock.disponible;

        // Materia Prima y Esmalte REQUIEREN unidad
        if (tipo == 'Materia Prima') unidad = 'Kg';
        if (tipo == 'Esmalte') unidad = 'Litros';
        if (tipo == 'Molde') unidad = 'Pieza';
      }

      final newItem = InventarioItem(
        id: '', // La BD genera el ID
        nombre: nombreItem,
        codigo:
            '${tipo.substring(0, 3).toUpperCase()}-00$i', // Ej: PRO-001, MAT-001
        tipo: tipo,
        stockInicial: 100,
        stockActual: 80 + i, // Un número arbitrario
        unidad: unidad,
        estadoProducto: estProducto,
        estadoStock: estStock,
        imagenReferencial: null,
      );

      try {
        await inventarioService.addInventarioItem(newItem);
        print('   ✅ Insertado: ${newItem.nombre}');
      } catch (e) {
        print('   ❌ Error insertando ${newItem.nombre}: $e');
      }
    }
  }
  print('✨ Poblamiento de Inventario completado.');
}

// =======================================================
// 2. SEEDING PARA RECETAS (10 registros)
// =======================================================
Future<void> seedRecetas() async {
  final recetaService = RecetaService();
  final inventarioService = InventarioService();

  print('🌱 Iniciando Seed para Recetas...');

  // PASO CRÍTICO: Obtener ítems reales del inventario para usarlos como ingredientes
  // Necesitamos materias primas o esmaltes reales para que la FK (Foreign Key) sea válida.
  List<InventarioItem> todosItems = [];
  try {
    // Obtenemos el snapshot actual de la base de datos
    todosItems = await inventarioService.getInventario().first;
  } catch (e) {
    print(
      '   ⚠️ No se pudo obtener inventario. Asegúrate de correr seedInventario primero.',
    );
    return;
  }

  // Filtramos solo lo que sirve para recetas
  final ingredientesDisponibles = todosItems
      .where((item) => item.tipo == 'Materia Prima' || item.tipo == 'Esmalte')
      .toList();

  if (ingredientesDisponibles.isEmpty) {
    print('   ⚠️ No hay materia prima ni esmaltes para crear recetas.');
    return;
  }

  final random = Random();

  for (int i = 1; i <= 10; i++) {
    // Crear una lista de ingredientes aleatorios (1 o 2 por receta)
    List<RecetaMateriaPrima> ingredientesReceta = [];

    // Elegir un ingrediente al azar
    final item1 =
        ingredientesDisponibles[random.nextInt(ingredientesDisponibles.length)];

    ingredientesReceta.add(
      RecetaMateriaPrima(
        inventarioId: item1.id, // ID real de Supabase
        nombre: item1.nombre,
        proporcion: (random.nextInt(50) + 10)
            .toDouble(), // Proporción aleatoria
      ),
    );

    final newReceta = Receta(
      id: '',
      nombre: 'Receta Maestra #$i',
      descripcion: 'Fórmula de prueba generada automáticamente n°$i',
      materiaPrima: ingredientesReceta,
      imagenReferencial: null,
    );

    try {
      await recetaService.addReceta(newReceta);
      print('   ✅ Receta creada: ${newReceta.nombre}');
    } catch (e) {
      print('   ❌ Error creando receta: $e');
    }
  }
  print('✨ Poblamiento de Recetas completado.');
}

// =======================================================
// 3. SEEDING PARA HORNADAS (10 registros)
// =======================================================
Future<void> seedHornadas() async {
  final hornadaService = HornadaService();

  print('🌱 Iniciando Seed para Hornadas...');

  for (int i = 1; i <= 10; i++) {
    // Generar fechas escalonadas (algunas pasadas, algunas futuras)
    // Hornadas pasadas = Finalizadas, Futuras = Programadas
    final diasOffset = i - 5; // -4 dias atras hasta +5 dias adelante
    final fechaPlan = DateTime.now().add(Duration(days: diasOffset));

    // Determinar estado basado en la fecha
    String estado = 'programada'; // Valor del enum HornadaEstado (string en DB)
    DateTime? horaInicio;
    DateTime? horaFin;
    String? observaciones;

    if (diasOffset < 0) {
      estado = 'finalizada';
      horaInicio = fechaPlan.subtract(const Duration(hours: 8));
      horaFin = fechaPlan;
      observaciones = 'Hornada completada con éxito.';
    } else if (diasOffset == 0) {
      estado = 'enCurso';
      horaInicio = DateTime.now();
    }

    // Alternar tipo/perfil
    final perfil = (i % 2 == 0) ? 'Bizcocho' : 'Esmalte';

    final newHornada = Hornada(
      id: '',
      fechaPlanificada: fechaPlan,
      perfilTemperatura: perfil,
      estado: estado,
      horno: 'Horno Eléctrico Principal',
      horaInicio: horaInicio,
      horaInicioReal: horaInicio,
      horaFin: horaFin,
      observaciones: observaciones,
    );

    try {
      await hornadaService.addHornada(newHornada);
      print(
        '   ✅ Hornada agendada: ${fechaPlan.toString().substring(0, 10)} ($estado)',
      );
    } catch (e) {
      print('   ❌ Error creando hornada: $e');
    }
  }
  print('✨ Poblamiento de Hornadas completado.');
}

// =======================================================
// FUNCIÓN PRINCIPAL PÚBLICA
// =======================================================
Future<void> seedDatabase() async {
  print('\n🔵 INICIANDO POBLAMIENTO DE BASE DE DATOS...\n');

  await seedInventario();
  // Esperamos un momento para asegurar consistencia si la BD es lenta
  await Future.delayed(const Duration(seconds: 1));
  await seedRecetas();
  await seedHornadas();

  print('\n🟢 PROCESO FINALIZADO.\n');
}
