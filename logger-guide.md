# Logger Guide (Flutter + Riverpod + Supabase)
คู่มือศึกษา Logger แบบ Step-by-Step  
สำหรับ Flutter Developer ที่ต้องการเข้าใจ flow จริงของแอป  
ไม่ใช่แค่พิมพ์ log แต่ “รู้ว่า log เพื่ออะไร”

---

## 1) Logger คืออะไร
Logger คือเครื่องมือบันทึกเหตุการณ์ระหว่างที่แอปทำงาน  
ช่วยให้ dev วิเคราะห์ว่า:

- โค้ดส่วนไหนทำงานอยู่
- state เปลี่ยนเมื่อไหร่
- API โหลดสำเร็จหรือพัง
- Stream ยิง event หรือยัง
- ผู้ใช้กดอะไรบ้าง
- error เกิดจากไหน

Logger = ไฟฉายส่อง bug

---

## 2) ติดตั้ง Logger

```yaml
dependencies:
  logger: ^2.0.2
```

---

## 3) สร้าง Logger

```dart
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(),
);
```

---

## 4) ระดับของ Log

| Level | ใช้ทำอะไร |
|-------|------------|
| logger.v() | ละเอียดมาก ใช้ดู state |
| logger.d() | Debug ตอน dev |
| logger.i() | แจ้งสถานะทั่วไป |
| logger.w() | คำเตือน |
| logger.e() | มี error |
| logger.wtf() | พังหนักมาก |

ตัวอย่าง:

```dart
logger.d("Loading products...");
logger.e("API failed", error: e, stackTrace: st);
```

---

## 5) ดู Logger ตรงไหน
VS Code → Debug Console  
ข้อความจะขึ้นแบบนี้:

```
I/flutter: [DEBUG] Loading products...
I/flutter: [ERROR] API failed
```

---

## 6) ใช้ Logger ใน FutureProvider (โหลดครั้งเดียว)

```dart
final productProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  logger.i("➡ productProvider started");

  try {
    final data = await Supabase.instance.client
        .from('products')
        .select();

    logger.d("✔ loaded: ${data.length} products");
    return data;
  } catch (e, st) {
    logger.e("❌ productProvider error", error: e, stackTrace: st);
    rethrow;
  }
});
```

---

## 7) ใช้ Logger ใน StreamProvider (เรียลไทม์)

```dart
final productStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  logger.i("➡ productStreamProvider started");

  final stream = Supabase.instance.client
      .from('products')
      .stream(primaryKey: ['id']);

  return stream.map((data) {
    logger.w("🔄 realtime update: ${data.length} items");
    return data;
  });
});
```

ทุกครั้งที่ข้อมูลเปลี่ยน → จะมี log เด้งออกมา

---

## 8) Provider Family + Logger

```dart
final productByIdProvider =
    FutureProvider.family((ref, int id) async {
  logger.i("➡ productById($id) start");

  try {
    final data = await Supabase.instance.client
        .from('products')
        .select()
        .eq('id', id)
        .single();

    logger.d("✔ result($id): ${data['name']}");
    return data;
  } catch (e, st) {
    logger.e("❌ error productById($id)", error: e, stackTrace: st);
    rethrow;
  }
});
```

---

## 9) ใช้ Logger กับ Riverpod ref.listen()

```dart
ref.listen(productStreamProvider, (prev, next) {
  logger.v("🌱 productStream changed → $next");
});
```

ใช้ดูขั้นตอน loading → data → update

---

## 10) Log User Interaction (สำคัญที่สุด)

```dart
onTap: () {
  logger.i("Tap product id=${item['id']}");
  context.push('/product_detail/${item['id']}');
}
```

รู้ทันทีว่าผู้ใช้ทำอะไรตอนเกิด bug

---

## 11) อะไรควร Log และไม่ควร Log

### ควร log:
- เริ่มโหลดข้อมูล
- ผลลัพธ์ API
- จำนวนรายการที่โหลด
- error จาก Supabase
- ผู้ใช้กดปุ่ม
- state เปลี่ยน

### ไม่ควร:
- password / token
- payload ใหญ่ทั้งก้อน
- log ในลูปหนักๆ
- log ซ้ำในทุกชั้น

---

## 12) โครงสร้าง Logger แบบโปรเจกต์ใหญ่

```
lib/
 └── core/
      └── app_logger.dart
```

ไฟล์:

```dart
import 'package:logger/logger.dart';

class AppLogger {
  static final log = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 3,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );
}
```

ใช้:

```dart
AppLogger.log.i("Load dashboard...");
```

---

## 13) เส้นทางศึกษาต่อ (Step-by-step)

1) ฝึกใช้ logger.d() ใน FutureProvider  
2) ดู log ใน Debug Console  
3) เพิ่ม log ใน StreamProvider  
4) ฝึก ref.listen() + logger  
5) สร้างไฟล์ app_logger.dart  
6) แยก logger dev/prod  
7) ส่ง log ไปเก็บที่ Supabase (ขั้นโปร)

---

## 14) สรุป

- Logger คือเครื่องมือส่อง flow ของแอป  
- ใช้ดี → debug เร็วขึ้น 5 เท่า  
- FutureProvider = log ตอนเริ่ม + สำเร็จ + error  
- StreamProvider = log ตอนมี event  
- Riverpod listen = log ตอน state เปลี่ยน  
- UI = log ตอน user ทำ action  

ฝึกทีละ step → เก่งขึ้นแน่นอน
