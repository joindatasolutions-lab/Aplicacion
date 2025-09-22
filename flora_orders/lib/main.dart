import 'package:flutter/material.dart';
import 'theme.dart';
import 'features/orders/orders_list_page.dart';

void main() {
  runApp(const FloraApp());
}

class FloraApp extends StatelessWidget {
  const FloraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flora - Gestión de pedidos',
      debugShowCheckedModeBanner: false,
      theme: buildFloraTheme(),
      home: const OrdersListPage(),
    );
  }
}
