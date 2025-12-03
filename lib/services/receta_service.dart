import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:proyecto_conde_ceramicas/model/receta_model.dart';

class RecetaService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _tableName = 'recetas';
  final String _joinTableName = 'receta_materia_prima';
  final String _bucketName = 'imagenes_conde_ceramica';

  // Helper to upload image
  Future<String?> _uploadImage(String path) async {
    try {
      final file = File(path);
      final fileName =
          'receta_${DateTime.now().millisecondsSinceEpoch}_${path.split(Platform.pathSeparator).last}';
      await _client.storage.from(_bucketName).upload(fileName, file);
      return _client.storage.from(_bucketName).getPublicUrl(fileName);
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  // Create
  Future<void> addReceta(Receta receta) async {
    String? imageUrl = receta.imagenReferencial;

    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        !imageUrl.startsWith('http')) {
      imageUrl = await _uploadImage(imageUrl);
    }

    // 1. Insert Receta
    final recetaData = receta.toMap();
    if (imageUrl != null) {
      recetaData['imagen_referencial'] = imageUrl;
    }

    // Remove ID if empty to let DB generate it
    if (receta.id.isEmpty) {
      recetaData.remove('id');
    }

    final response = await _client
        .from(_tableName)
        .insert(recetaData)
        .select()
        .single();

    final newRecetaId = response['id'];

    // 2. Insert Materia Prima links
    if (receta.materiaPrima.isNotEmpty) {
      final materiaPrimaData = receta.materiaPrima.map((mp) {
        return {
          'receta_id': newRecetaId,
          'inventario_id': mp.inventarioId,
          'proporcion': mp.proporcion,
        };
      }).toList();

      await _client.from(_joinTableName).insert(materiaPrimaData);
    }
  }

  // Read
  Future<List<Receta>> getRecetas() async {
    try {
      final response = await _client
          .from(_tableName)
          .select('*, $_joinTableName(*, inventario(nombre))');

      final data = response as List<dynamic>;
      return data
          .map((map) => Receta.fromMap(map as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching recetas: $e');
      return [];
    }
  }

  // Update
  Future<void> updateReceta(Receta receta) async {
    String? imageUrl = receta.imagenReferencial;

    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        !imageUrl.startsWith('http')) {
      imageUrl = await _uploadImage(imageUrl);
    }

    final recetaData = receta.toMap();
    if (imageUrl != null) {
      recetaData['imagen_referencial'] = imageUrl;
    }

    // 1. Update Receta
    await _client.from(_tableName).update(recetaData).eq('id', receta.id);

    // 2. Update Materia Prima
    await _client.from(_joinTableName).delete().eq('receta_id', receta.id);

    if (receta.materiaPrima.isNotEmpty) {
      final materiaPrimaData = receta.materiaPrima.map((mp) {
        return {
          'receta_id': receta.id,
          'inventario_id': mp.inventarioId,
          'proporcion': mp.proporcion,
        };
      }).toList();

      await _client.from(_joinTableName).insert(materiaPrimaData);
    }
  }

  // Delete
  Future<void> deleteReceta(String id) async {
    try {
      final data = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .single();
      final receta = Receta.fromMap(data);

      if (receta.imagenReferencial != null &&
          receta.imagenReferencial!.isNotEmpty) {
        final imageUrl = receta.imagenReferencial!;
        final fileName = Uri.decodeComponent(imageUrl.split('/').last);
        await _client.storage.from(_bucketName).remove([fileName]);
      }
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }

    // 2. Delete Receta (Cascade will delete links)
    await _client.from(_tableName).delete().eq('id', id);
  }
}
