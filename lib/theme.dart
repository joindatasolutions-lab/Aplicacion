import 'package:flutter/material.dart';
import 'models/pedido.dart';

class AppTheme {
  // 🎨 Paleta basada en tu marca Flora
  static const Color primaryPink = Color(0xFFE5B4B3);
  static const Color lightPink = Color(0xFFF8E8E8);
  static const Color accentPink = Color(0xFFC98989);
  static const Color darkText = Color(0xFF444444);

  static final Map<PedidoEstado, Color> estadoColor = {
    PedidoEstado.pendiente: Color(0xFFFFC107),
    PedidoEstado.aprobado: Color(0xFF81C784),
    PedidoEstado.rechazado: Color(0xFFE57373),
    PedidoEstado.enPreparacion: Color(0xFFF9A825),
    PedidoEstado.listoEnvio: Color(0xFF64B5F6),
    PedidoEstado.finalizado: Color(0xFFBA68C8),
    PedidoEstado.enCamino: Color(0xFF4DB6AC),
    PedidoEstado.entregado: Color(0xFF81C784),
    PedidoEstado.incidencia: Color(0xFFE57373),
  };

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Nunito',
      primaryColor: primaryPink,
      scaffoldBackgroundColor: lightPink,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryPink.withOpacity(0.15),
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Playfair Display',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: darkText,
        ),
        iconTheme: const IconThemeData(color: darkText),
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        shadowColor: Color(0x33C98989), // 20% opacidad del accentPink
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        prefixIconColor: accentPink,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentPink, width: 2),
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: accentPink,
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        indicatorColor: accentPink,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 14, color: darkText),
        titleLarge: TextStyle(
          fontFamily: 'Playfair Display',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: darkText,
        ),
      ),
    );
  }
}
