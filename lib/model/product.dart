//โมเดล Product สำหรับดึงค่า จาก Supabase

class Product {
  final int id;
  final String name;
  final String price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });
}
