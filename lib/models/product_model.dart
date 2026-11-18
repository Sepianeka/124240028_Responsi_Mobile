class ProductModel {
  // Properti ini menjadi representasi tunggal data produk di seluruh aplikasi.
  final int id;
  final String title;
  final num price;
  final String description;
  final String category;
  final String image;
  final num rate;
  final int count;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rate,
    required this.count,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Mendukung beberapa format respons API, termasuk daftar gambar dan thumbnail.
    final images = json['images'];
    final firstImage = images is List && images.isNotEmpty
        ? images.first?.toString()
        : null;
    final sourceImage = (json['image']?.toString().isNotEmpty ?? false)
        ? json['image'].toString()
        : (json['thumbnail']?.toString().isNotEmpty ?? false
            ? json['thumbnail'].toString()
            : (firstImage ?? ''));
    final image = sourceImage.startsWith('https://fakestoreapi.com/')
        
        ? 'https://wsrv.nl/?url=${Uri.encodeComponent(sourceImage)}&w=800&h=800&fit=contain&output=webp'
        : sourceImage;

    // Mengubah nilai JSON menjadi atribut bertipe aman pada ProductModel.
    return ProductModel(
      id: json['id'] as int,
      title: json['title']?.toString() ?? '',
      price: json['price'] is num ? json['price'] as num : 0,
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      image: image,
      rate: json['rating'] is Map
          ? (json['rating']['rate'] is num
              ? json['rating']['rate'] as num
              : 0)
          : (json['rating'] is num ? json['rating'] as num : 0),
      count: json['rating'] is Map
          ? (json['rating']['count'] is num
              ? (json['rating']['count'] as num).toInt()
              : 0)
          : (json['reviews'] is List ? (json['reviews'] as List).length : 0),
    );
  }

  Map<String, dynamic> toMap() => {
        // Mengubah model menjadi Map agar dapat disimpan dan dibaca Hive.
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
        'rating': {'rate': rate, 'count': count},
      };
}
