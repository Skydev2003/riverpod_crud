import 'package:go_router/go_router.dart';
import 'package:riverpod_crud/screen/home_screen.dart';
import 'package:riverpod_crud/screen/note_screen.dart';


final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/note',
      builder: (context, state) => const NoteScreen(),
    ),
  ],
);
