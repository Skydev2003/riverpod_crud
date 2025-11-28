//เขีนน FutureProvider ดึงข้อมูลสินค้า ไม่เรียลทาม
// โหลดแบบ async ครั้งเดียว
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final logger = Logger();

final productProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
      final supabase = Supabase.instance.client;

      List<Map<String, dynamic>> data = [];

      try {
        data = await supabase.from('products').select();
      } catch (e, st) {
        logger.e('error', error: e, stackTrace: st);
      }

      return data;
    });

// ✦ นี่คือการโหลดสินค้าแบบ async
// ✦ productProvider จะให้ AsyncValue ออกมา

// เขียนStreamProvider ดึงข้อมูลสิค้าแบบเรียลทาม
// โหลดแบบ realtime
final productStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
      final supabase = Supabase.instance.client;
      logger.i('productStream Start');

      final data = supabase
          .from('products')
          .stream(primaryKey: ['id']);

      return data.map((data) {
        logger.w(
          'Wranning Realtime Update จำนวน ${data.length}',
        );

        return data;
      });
    });

// สร้าง Provider Family สำหรับ Product by ID
final productByIdProvider = FutureProvider.family((
  ref,
  int id,
) async {
  final supabase = Supabase.instance.client;

  final data = await supabase
      .from('products')
      .select()
      .eq('id', id)
      .single();

  return data;
});
