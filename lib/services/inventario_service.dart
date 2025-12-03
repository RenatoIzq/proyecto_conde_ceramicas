import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:proyecto_conde_ceramicas/model/inventario_model.dart';

class InventarioService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _tableName = 'inventario';
  final String _bucketName = 'imagenes_conde_ceramica';

  // Helper to upload image
  Future<String?> _uploadImage(String path) async {
    try {
      final file = File(path);
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.split(Platform.pathSeparator).last}';
      await _client.storage.from(_bucketName).upload(fileName, file);
      return _client.storage.from(_bucketName).getPublicUrl(fileName);
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  // Create
  Future<void> addInventarioItem(InventarioItem item) async {
    String? imageUrl = item.imagenReferencial;

    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        !imageUrl.startsWith('http')) {
      imageUrl = await _uploadImage(imageUrl);
    }

    final itemToSave = item.copyWith(imagenReferencial: imageUrl);

    final data = itemToSave.toMap();
    if (itemToSave.id.isEmpty) {
      data.remove('id');
    }

    await _client.from(_tableName).insert(data);
  }

  // Read
  Stream<List<InventarioItem>> getInventario() {
    return _client
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .map(
          (data) => data.map((item) => InventarioItem.fromMap(item)).toList(),
        );
  }

  // Update
  Future<void> updateInventarioItem(InventarioItem item) async {
    String? imageUrl = item.imagenReferencial;

    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        !imageUrl.startsWith('http')) {
      imageUrl = await _uploadImage(imageUrl);
    }

    final itemToSave = item.copyWith(imagenReferencial: imageUrl);

    await _client
        .from(_tableName)
        .update(itemToSave.toMap())
        .eq('id', itemToSave.id);
  }

  // Delete
  Future<void> deleteInventarioItem(String id) async {
    // 1. Fetch item to get image URL
    try {
      final data = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .single();
      final item = InventarioItem.fromMap(data);

      // 2. Delete image if exists
      if (item.imagenReferencial != null &&
          item.imagenReferencial!.isNotEmpty) {
        final imageUrl = item.imagenReferencial!;
        final fileName = Uri.decodeComponent(imageUrl.split('/').last);

        await _client.storage.from(_bucketName).remove([fileName]);
      }
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }

    // 3. Delete item from DB
    await _client.from(_tableName).delete().eq('id', id);
  }
}
