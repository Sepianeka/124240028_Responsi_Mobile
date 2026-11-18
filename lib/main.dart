import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'services/cart_service.dart';

Future<void> main() async {
  // Memastikan binding Flutter siap sebelum menjalankan penyimpanan lokal.
  WidgetsFlutterBinding.ensureInitialized();
  // Menginisialisasi Hive sebagai database lokal untuk keranjang belanja.
  await Hive.initFlutter();
  await Hive.openBox(CartService.boxName);

  // Membaca status login agar aplikasi dapat langsung masuk ke halaman utama.
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Menjalankan aplikasi dengan status login yang sudah disimpan.
  runApp(ShopediaApp(isLoggedIn: isLoggedIn));
}

class ShopediaApp extends StatelessWidget {
  final bool isLoggedIn;
  const ShopediaApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    // Menentukan warna utama dan konfigurasi tampilan global aplikasi.
    const green = Color(0xFF2E7D32);
    return MaterialApp(
      title: 'Shopedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        scaffoldBackgroundColor: const Color(0xFFF6F9F1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F9F1),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      home: isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}
