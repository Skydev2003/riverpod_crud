import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final nameProvider = StateProvider<String>((Ref ref) {
  String nameProvider = 'Riverpod';

  return nameProvider;
});


