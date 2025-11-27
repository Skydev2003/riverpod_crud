//สร้าง StateNotifier

import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_crud/model/note.dart';

class NoteNotifier extends StateNotifier<List<Note>> {
  NoteNotifier() : super([]);

  //ฟังก์ชัน เพิ่ม โน๊ต
  void add(Note note) {
    state = [...state, note];
  }

  //ฟังก์ชัน ลบ โน๊ต
  void delete(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  //ฟังก์ชัน อัพเดต โน๊ต
  void update(Note note) {
    state = [
      for (final n in state)
        if (n.id == note.id) note else n,
    ];
  }
}

//สร้าง StateNotifierProvider ให้ UI ใช้งานได้
final noteProvider =
    StateNotifierProvider<NoteNotifier, List<Note>>(
      (ref) => NoteNotifier(),
    );
  