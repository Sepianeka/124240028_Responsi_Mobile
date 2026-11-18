import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/cart_service.dart';
import 'detail_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ValueListenableBuilder(
        // Mendengarkan perubahan Hive agar daftar keranjang diperbarui otomatis.
        valueListenable: CartService.box.listenable(),
        builder: (context, _, __) {
          // Mengambil item terbaru dari penyimpanan keranjang.
          final items = CartService.items;
          if (items.isEmpty) {
            // Menampilkan pesan saat belum ada produk di keranjang.
            return const Center(child: Text('Keranjang masih kosong'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (_, i) {
              // Mengambil satu produk untuk ditampilkan pada setiap baris.
              final p = items[i];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    // Membuka detail produk jika item keranjang diklik.
                    MaterialPageRoute(
                        builder: (_) => DetailPage(productId: p.id)),
                  ),
                  leading: SizedBox(
                    width: 48,
                    height: 48,
                    child: Image.network(p.image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image)),
                  ),
                  title: Text(p.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\$${p.price}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary)),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text('${p.rate}',
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    // Menghapus produk dari keranjang berdasarkan ID.
                    onPressed: () => CartService.remove(p.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
