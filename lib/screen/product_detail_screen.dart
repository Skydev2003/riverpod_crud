import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_crud/provider/product_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.id, super.key});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productByIdProvider(id));

    return Scaffold(
      appBar: AppBar(title: Text('Product Detail')),
      body: productAsync.when(
        data: (i) {
          return Column(children: [
            Text(i['name']),
            Text('฿ ${i['price']}'),
          ],
        );
        },
        error: (e, st) => Center(child: Text('$e')),
        loading: () =>
            Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
