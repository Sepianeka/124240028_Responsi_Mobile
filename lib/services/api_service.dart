import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/product.dart';

class ApiService {
  // URL dasar untuk endpoint daftar dan detail produk Fake Store.
  static const String _baseUrl = 'https://fakestoreapi.com/products';
  // Header yang dikirim untuk meminta respons JSON dan mengidentifikasi aplikasi.
  static const Map<String, String> _headers = {
    'Accept': 'application/json',
    'User-Agent': 'Mozilla/5.0 (Shopedia Flutter App)',
  };

  /// GET https://fakestoreapi.com/products
  Future<List<ProductModel>> fetchProducts() async {
    try {
      // Mengambil daftar produk dari API dengan batas waktu permintaan.
      final res = await http
          .get(Uri.parse(_baseUrl), headers: _headers)
          .timeout(const Duration(seconds: 20));
      if (res.statusCode == 200) {
        // Mengonversi respons JSON menjadi daftar ProductModel.
        final data = jsonDecode(res.body) as List<dynamic>;
        return data
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Gunakan data lokal bila API tidak dapat dijangkau.
    }
    // Fallback memastikan aplikasi tetap menampilkan produk tanpa koneksi API.
    return products
        .map((item) => ProductModel.fromJson(item))
        .toList();
  }

  /// GET https://fakestoreapi.com/products/{id}
  Future<ProductModel> fetchProductDetail(int id) async {
    try {
      // Mengambil detail satu produk berdasarkan ID dari API.
      final res = await http
          .get(Uri.parse('$_baseUrl/$id'), headers: _headers)
          .timeout(const Duration(seconds: 20));
      if (res.statusCode == 200) {
        // Mengubah respons detail JSON menjadi satu objek ProductModel.
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return ProductModel.fromJson(data);
      }
    } catch (_) {
      // Gunakan data lokal bila API tidak dapat dijangkau.
    }
    final item = products.firstWhere(
      // Mencari produk pada data lokal berdasarkan ID.
      (product) => product['id'] == id,
      orElse: () => products.first,
    );
    return ProductModel.fromJson(item);
  }
}
