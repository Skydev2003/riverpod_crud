import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
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
      body: Text('product'),
    );
  }
}
