# Upskill: Logging & Error Handling สำหรับ Flutter + Riverpod

การจัดการ **Logging** และ **Error Handling** คือทักษะที่ทำให้โค้ดของเราโตจากระดับนักเรียน → ระดับโปรดักชันได้จริง เอกสารนี้ออกแบบมาให้สกายอ่านง่าย ใช้งานได้ทันที พร้อมตัวอย่างที่เหมือนใช้อยู่ใน WeWeight2 / Kinroo

---

## 1) ใช้ Logger ให้ถูกต้อง (เลิกใช้ print)
ติดตั้ง:
```
flutter pub add logger
```

ใช้งาน:
```dart
import 'package:logger/logger.dart';

final logger = Logger();

logger.d("Debug message");
logger.i("Info something");
logger.w("Warning something strange");
logger.e("Error happened", error, stackTrace);
```

ข้อดี:
- มีสี
- มีระดับ log
- มี stacktrace
- ปิด log ตอน release ได้

---

## 2) โครงสร้าง Logging แบบโปรดักชัน

ตัวอย่าง Repository:

```dart
class ProductRepository {
  final supabase = Supabase.instance.client;

  Future<List<Product>> fetchAll() async {
    logger.i("[ProductRepository] Fetching products...");

    try {
      final data = await supabase.from('products').select();

      logger.d("[ProductRepository] Success: ${data.length} items");
      return data.map((e) => Product.fromJson(e)).toList();

    } catch (e, st) {
      logger.e("[ProductRepository] Failed to load products", e, st);
      rethrow;
    }
  }
}
```

หลักการคือ:
1. ก่อนเริ่มงาน → `logger.i`
2. ทำสำเร็จ → `logger.d`
3. ล้มเหลว → `logger.e` พร้อม stacktrace

---

## 3) Error Handling แบบโปรดักชัน

### Error Class กลาง

```dart
class AppException implements Exception {
  final String message;
  final String code;

  AppException(this.message, this.code);

  factory AppException.network() =>
      AppException("Network error, try again.", "NETWORK");

  factory AppException.database(String msg) =>
      AppException("Database error: $msg", "DB");

  factory AppException.unknown() =>
      AppException("Something went wrong", "UNKNOWN");
}
```

### ใช้ภายใน Repository

```dart
try {
  final result = await supabase.from('products').select();
  return result;
} on PostgrestException catch (e, st) {
  logger.e("Database error", e, st);
  throw AppException.database(e.message);
} catch (e, st) {
  logger.e("Unknown error", e, st);
  throw AppException.unknown();
}
```

---

## 4) AsyncValue + Riverpod = อ่าน error ง่ายที่สุด

Provider:
```dart
final productProvider = FutureProvider((ref) async {
  try {
    final repo = ref.watch(productRepoProvider);
    return repo.fetchAll();
  } catch (e, st) {
    logger.e("productProvider error", e, st);
    throw e;
  }
});
```

UI:
```dart
final products = ref.watch(productProvider);

return products.when(
  loading: () => const CircularProgressIndicator(),
  data: (data) => ProductList(data),
  error: (e, st) {
    logger.e("UI error", e, st);
    return Text("Error: $e");
  },
);
```

---

## 5) การฟัง Error แบบโปรดักชัน: ref.listen

```dart
ref.listen(productProvider, (prev, next) {
  next.whenOrNull(
    error: (e, st) {
      if (e is AppException) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unexpected error")),
        );
      }
    },
  );
});
```

---

## 6) วิธี Debug ให้เป็นระบบ (ไม่เดามั่ว)

1) หาว่า error อยู่ในชั้นไหน  
- UI  
- Provider  
- Repository  
- Platform (USB/Bluetooth)

2) ใส่ log ตรง bottleneck  
ตัวอย่าง Kotlin USB:
```kotlin
Log.d("SerialScale", "startReadingSerialData");
```

3) จำลอง Error ด้วยตัวเอง  
- ปิดเน็ต  
- ทำ Supabase column ชื่อผิด  
- ส่งค่า null  
- ปิด Bluetooth  
- ถอด USB  

---

## 7) Checklist สรุปสำหรับติดโต๊ะ

### Logging
- มี logger กลาง
- ทุก function สำคัญต้อง log: เริ่ม / สำเร็จ / ผิดพลาด

### Error
- ห้าม throw string
- ทุก error ต้องใช้ AppException
- UI ใช้ ref.listen จับ error ให้ผู้ใช้เห็น

### Debug
- อ่าน stacktrace ให้เป็น
- เพิ่ม log เฉพาะจุดสำคัญ
- จำลอง error ให้ครบทุกแบบ

---

## 8) โค้ดสากลที่สามารถคัดลอกไปใช้ได้ทันที

### logger.dart
```dart
import 'package:logger/logger.dart';

class Log {
  static final logger = Logger();

  static d(msg) => logger.d(msg);
  static i(msg) => logger.i(msg);
  static w(msg) => logger.w(msg);
  static e(msg, [err, st]) => logger.e(msg, err, st);
}
```

### error.dart
```dart
class AppException implements Exception {
  final String message;
  final String code;

  AppException(this.message, this.code);

  factory AppException.network() =>
      AppException("Network error", "NETWORK");

  factory AppException.database(String message) =>
      AppException("Database Error: $message", "DATABASE");

  factory AppException.unknown() =>
      AppException("Unknown error", "UNKNOWN");
}
```

---

## สรุป
ชุดทักษะนี้จะทำให้สกายกลายเป็น Flutter Dev ที่แก้ไขปัญหาได้จริงแบบทีมโปรดักชัน ใช้กับทุกโปรเจค—ไม่ว่าจะเป็น WeWeight2, Kinroo, หรือระบบที่ลูกค้าจ้างในอนาคต

---

ถ้าต้องการเวอร์ชัน Clean Architecture แบบเต็มระบบ (Repository + Service + Provider + UI) บอกได้เลย พร้อมจัดให้ทั้งโครงสร้างโปรเจค
