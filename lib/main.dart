import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_crud/routes/app_route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yvbqbkwvqwcamjimesav.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl2YnFia3d2cXdjYW1qaW1lc2F2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQyMTQ2OTUsImV4cCI6MjA3OTc5MDY5NX0.-kUypM7McnYvAIkHjuzDXXqL6Hp2aok8sZDuiXwakFI',
  );
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
