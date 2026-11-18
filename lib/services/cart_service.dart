import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';

/// Pengelolaan keranjang menggunakan Hive.
class CartService {
  // Nama box Hive yang digunakan untuk menyimpan seluruh produk keranjang.
  static const String boxName = 'cart';

  // Mengakses box keranjang yang telah dibuka saat aplikasi dimulai.
  static Box get box => Hive.box(boxName);

  // Menambah produk ke keranjang dan menyimpannya berdasarkan ID produk.
  static Future<void> add(dynamic p) => box.put(
        p.id,
        p is ProductModel
            ? p.toMap()
            : Map<String, dynamic>.from(p as Map),
      );

  static Future<void> remove(int id) => box.delete(id);

  // Mengecek apakah produk sudah ada agar tombol keranjang dapat dinonaktifkan.
  static bool contains(int id) => box.containsKey(id);

  // Menghitung jumlah jenis produk yang tersimpan di keranjang.
  static int get count => box.length;

  // Mengambil semua item keranjang lalu mengonversinya kembali menjadi model.
  static List<ProductModel> get items =>
      box.values.map((item) => ProductModel.fromJson(
          Map<String, dynamic>.from(item as Map))).toList();
}
