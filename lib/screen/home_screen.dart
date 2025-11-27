import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_crud/provider/couter_provider.dart';
import 'package:riverpod_crud/provider/name_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String name = ref.watch(nameProvider);
    final int couter = ref.watch(couterProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(child: Text(name)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              const Color.fromARGB(255, 66, 7, 108),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                couter.toString(),
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(couterProvider.notifier).state++,
              label: Text('add couter'),
            ),
            SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                // ref.read(couterProvider.notifier).state--;
                ref.read(nameProvider.notifier).state =
                    'สกาย';
              },
              label: Text('delete couter'),
            ),
            SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(couterProvider.notifier).state = 0,
              label: Text('reset couter'),
            ),
            SizedBox(height: 40),
            TextButton.icon(
              onPressed: () {
                ref.context.push('/note');
              },
              label: Text('ไปหน้า Note'),
            ),
          ],
        ),
      ),
    );
  }
}
