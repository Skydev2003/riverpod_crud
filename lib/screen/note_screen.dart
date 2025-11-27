import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_crud/model/note.dart';
import 'package:riverpod_crud/provider/note_provider.dart';

class NoteScreen extends ConsumerWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(noteProvider);

    //กล่องเพิ่มข้อความ
    void showAddNoteDialog(
      BuildContext context,
      WidgetRef ref,
    ) {
      final controller = TextEditingController();

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('เพิ่มโน๊ต'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'พิมพ์ข้อความ',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ยกเลิก'),
              ),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(noteProvider.notifier)
                      .add(
                        Note(
                          id: DateTime.now().toString(),
                          title: controller.text,
                        ),
                      );

                  Navigator.pop(context);
                },
                child: const Text('บันทึก'),
              ),
            ],
          );
        },
      );
    }

    //กล่องแก้ไขข้อความ
    void showEditNoteDialog(
      BuildContext context,
      WidgetRef ref,
      Note note,
    ) {
      final controller = TextEditingController(
        text: note.title,
      );

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('แก้ไขโน๊ต'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'แก้ไขข้อความ',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ยกเลิก'),
              ),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(noteProvider.notifier)
                      .update(
                        Note(
                          id: note.id, // ใช้ id เดิม
                          title: controller
                              .text, // ข้อความใหม่
                        ),
                      );

                  Navigator.pop(context);
                },
                child: const Text('บันทึก'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.context.pop();
          },
        ),
        title: const Text("Note"),
        actions: [
          IconButton(
            onPressed: () {
              ref.context.push('/product');
            },
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, i) {
                final note = notes[i];
                return ListTile(
                  title: Text(note.title),
                  onTap: () {
                    showEditNoteDialog(context, ref, note);
                  },
                  trailing: IconButton(
                    onPressed: () {
                      ref
                          .read(noteProvider.notifier)
                          .delete(note.id);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddNoteDialog(context, ref),
        child: Text('เพิ่ม '),
      ),
    );
  }
}
