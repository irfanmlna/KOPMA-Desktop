import 'package:flutter/material.dart';
import 'package:kopma_app/screens/barang.dart';
import 'package:kopma_app/screens/kategori.dart';
import 'package:kopma_app/screens/login_screen.dart';
import 'package:kopma_app/screens/supplier.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kopma',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      navigatorKey: navigatorKey,
      home: LoginScreen(navigatorKey: navigatorKey),
      routes: {
        '/kategori': (context) => KategoriPage(),
        '/barang': (context) => BarangPage(),
        '/supplier': (context) => SupplierPage(),
      },
    );
  }
}
