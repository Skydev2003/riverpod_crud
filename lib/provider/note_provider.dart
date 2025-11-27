

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_crud/model/note.dart';


// สร้าง NotifieProvider
class NoteNotifier extends Notifier<List<Note>> {
  @override
  List<Note> build() {
    return [];
  }
  // ฟังก์ชัน เพิ่ม 
  void add(Note note) {
    state = [...state, note];
  }
  // ฟังก์ชัน ลบ 
  void delete(String id) {
    state = state.where((n) => n.id != id).toList();
  }
  // ฟังก์ชัน อัพเดต 
  void update(Note note) {
    state = [
      for (final n in state)
        if (n.id == note.id) note else n,
    ];
  }
}
// 2. สร้าง Provider โดยใช้ NotifierProvider (ตัดคำว่า State ออก)
final noteProvider =
    NotifierProvider<NoteNotifier, List<Note>>(
      () => NoteNotifier()
    );
