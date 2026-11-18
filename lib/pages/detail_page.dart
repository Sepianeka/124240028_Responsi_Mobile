import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import 'cart_page.dart';

class DetailPage extends StatefulWidget {
  final int productId;
  const DetailPage({super.key, required this.productId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Menyimpan permintaan detail produk berdasarkan ID halaman.
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    // Memanggil API detail saat halaman detail dibuka.
    _future = ApiService().fetchProductDetail(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            ),
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: _future,
        builder: (context, snap) {
          // Menampilkan indikator proses saat detail sedang dimuat.
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            // Menampilkan pesan jika data detail gagal dimuat.
            return Center(child: Text('${snap.error}'));
          }
          final p = snap.data!;
          // Menata gambar, nama, harga, rating, dan deskripsi produk.
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero image (paling atas & besar)
                      Container(
                        width: double.infinity,
                        height: 320,
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Image.network(
                          p.image,
                          fit: BoxFit.contain,
                          loadingBuilder: (c, child, prog) => prog == null
                              ? child
                              : const Center(
                                  child: CircularProgressIndicator()),
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 60),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title, style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 6),
                            Text('\$${p.price}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text('${p.rate}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(width: 4),
                                Text('(${p.count} review)',
                                    style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text('Deskripsi Produk',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(p.description,
                                style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Button berubah sesuai status di keranjang (reaktif lewat Hive)
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ValueListenableBuilder(
                    valueListenable: CartService.box.listenable(),
                    builder: (context, _, __) {
                      // Membaca ulang status keranjang agar tombol selalu sinkron.
                      final inCart = CartService.contains(p.id);
                      return SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton.icon(
                          onPressed: inCart
                              ? null
                              : () async {
                                  // Menyimpan produk ke Hive lalu menampilkan pemberitahuan.
                                  await CartService.add(p);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Ditambahkan ke keranjang')),
                                  );
                                },
                          icon: Icon(inCart
                              ? Icons.check
                              : Icons.add_shopping_cart),
                          label: Text(inCart
                              ? 'Sudah di Keranjang'
                              : 'Masukkan ke Keranjang'),
                          style: FilledButton.styleFrom(
                            backgroundColor: inCart
                                ? Colors.grey.shade700
                                : Theme.of(context).colorScheme.primary,
                            disabledBackgroundColor: Colors.grey.shade700,
                            disabledForegroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
