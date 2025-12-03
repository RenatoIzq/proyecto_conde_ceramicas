import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:proyecto_conde_ceramicas/model/hornadas_model.dart';

class HornadaService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _tableName = 'hornadas';

  // Read (Stream)
  Stream<List<Hornada>> getHornadas() {
    return _client
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .order('fecha_planificada')
        .map((data) => data.map((map) => Hornada.fromMap(map)).toList());
  }

  // Create
  Future<void> addHornada(Hornada hornada) async {
    try {
      final data = hornada.toMap();
      if (hornada.id.isEmpty) {
        data.remove('id');
      }
      await _client.from(_tableName).insert(data);
    } catch (e) {
      debugPrint('Error adding hornada: $e');
      rethrow;
    }
  }

  // Update
  Future<void> updateHornada(Hornada hornada) async {
    try {
      await _client
          .from(_tableName)
          .update(hornada.toMap())
          .eq('id', hornada.id);
    } catch (e) {
      debugPrint('Error updating hornada: $e');
      rethrow;
    }
  }

  // Delete
  Future<void> deleteHornada(String id) async {
    try {
      await _client.from(_tableName).delete().eq('id', id);
    } catch (e) {
      debugPrint('Error deleting hornada: $e');
      rethrow;
    }
  }
}
