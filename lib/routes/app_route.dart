import 'package:go_router/go_router.dart';
import 'package:riverpod_crud/screen/home_screen.dart';
import 'package:riverpod_crud/screen/note_screen.dart';
import 'package:riverpod_crud/screen/product_detail_screen.dart';
import 'package:riverpod_crud/screen/product_screen.dart';

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
    GoRoute(
      path: '/product',
      builder: (context, state) => const ProductScreen(),
    ),
    GoRoute(
      path: '/product_detail/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductDetailScreen(id: id);
      },
    ),
   ],
);
