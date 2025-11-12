import 'package:flutter/material.dart';
import 'screens/pipeline_screen.dart';
import 'mock_data.dart'; // ✅ importamos los mocks
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      //home: PipelineScreen(pedidos: mockPedidos), // ✅ usamos mockPedidos

      home: const PipelineScreen(), // ✅ original reemplazar ahora mas tarde
    );
  }
}
