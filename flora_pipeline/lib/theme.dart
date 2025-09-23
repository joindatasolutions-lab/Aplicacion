import 'package:flutter/material.dart';
import 'models/pedido.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF0078D4);
  static const Color darkText = Color(0xFF333333);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color mediumGrey = Color(0xFFE0E0E0);

  static final Map<PedidoEstado, Color> estadoColor = {
    PedidoEstado.pendiente: Colors.amber,
    PedidoEstado.aprobado: Colors.green,
    PedidoEstado.rechazado: Colors.red,
    PedidoEstado.enPreparacion: Colors.orange,
    PedidoEstado.listoEnvio: Colors.blue,
    PedidoEstado.enCamino: Colors.indigo,
    PedidoEstado.entregado: Colors.teal,
    PedidoEstado.incidencia: Colors.redAccent,
  };

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: lightGrey,
      fontFamily: 'Roboto',

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: darkText,
        elevation: 1,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
      ),

      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF444444),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: Color(0xFF666666),
        ),
      ),

      // ✅ Aquí corregido
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        shadowColor: Colors.black.withOpacity(0.05),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        ),
      

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: mediumGrey,
        thickness: 1,
      ),
    );
  }
}
