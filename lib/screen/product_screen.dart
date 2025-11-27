import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_crud/provider/product_provider.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final productAsync = ref.watch(productProvider);
    final productsAsyncStream = ref.watch(
      productStreamProvider,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Product'),
        leading: IconButton(
          onPressed: () {
            ref.context.pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: productsAsyncStream.when(
        data: (products) {
          return ListView(
            children: [
              for (final i in products)
                ListTile(
                  onTap: () {
                    context.push(
                      '/product_detail/${i['id']}',
                    );
                  },
                  title: Text(i['name']),
                  subtitle: Text('฿ ${i['price']}'),
                ),
            ],
          );
        },
        error: (e, st) => Center(child: Text('$e')),
        loading: () => Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
