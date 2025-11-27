//เขีนน FutureProvider ดึงข้อมูลสินค้า ไม่เรียลทาม
// โหลดแบบ async ครั้งเดียว
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final productProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
      final supabase = Supabase.instance.client;

      final data = await supabase.from('products').select();

      return data;
    });
// ✦ นี่คือการโหลดสินค้าแบบ async
// ✦ productProvider จะให้ AsyncValue ออกมา

// เขียนStreamProvider ดึงข้อมูลสิค้าแบบเรียลทาม
// โหลดแบบ realtime
final productStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
      final supabase = Supabase.instance.client;

      final data = supabase
          .from('products')
          .stream(primaryKey: ['id']);

      return data;
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
