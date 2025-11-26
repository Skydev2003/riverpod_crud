import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_crud/model/note.dart';

class NoteNotifier extends StateNotifier<List<Note>> {
  NoteNotifier() : super([]);

  void add(Note note) {
    state = [...state, note];
  }

  void delete(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  void update(Note note) {
    state = [
      for (final n in state)
        if (n.id == note.id) note else n,
    ];
  }
}

final noteProvider =
    StateNotifierProvider<NoteNotifier, List<Note>>(
      (ref) => NoteNotifier(),
    );
