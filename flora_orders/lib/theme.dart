import 'package:flutter/material.dart';

// Colores de marca extraídos del logo
const kFloraWhite = Color(0xFFFEFEFE);
const kFloraIvory = Color(0xFFFAF7EC);
const kFloraBlush = Color(0xFFEDD5DA);
const kFloraDust  = Color(0xFFDCC7C4);
const kFloraSage  = Color(0xFFBDBEAD);
const kFloraRose  = Color(0xFFD996A5); // Primary
const kFloraTaupe = Color(0xFF948685);
const kFloraTeal  = Color(0xFF7BA9BA); // Secondary

ThemeData buildFloraTheme() {
  const primary = kFloraRose;
  const secondary = kFloraTeal;
  const background = kFloraIvory;
  const surface = kFloraWhite;

  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    secondary: secondary,
    onSecondary: Colors.white,
    error: const Color(0xFFB00020),
    onError: Colors.white,
    background: background,
    onBackground: kFloraTaupe,
    surface: surface,
    onSurface: kFloraTaupe,
    outline: kFloraSage,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      foregroundColor: kFloraTaupe,
      elevation: 0,
      centerTitle: true,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: kFloraBlush,
      selectedColor: primary,
      labelStyle: const TextStyle(color: kFloraTaupe),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primary,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kFloraTaupe,
        side: const BorderSide(color: kFloraRose, width: 1.2),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),

    // 👇 Cambio clave: usar CardThemeData en lugar de CardTheme
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    dividerTheme: const DividerThemeData(color: kFloraSage),
  );
}
