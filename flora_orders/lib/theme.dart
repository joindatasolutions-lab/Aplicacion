import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colores de marca
const kFloraWhite = Color(0xFFFEFEFE);
const kFloraIvory = Color(0xFFFAF7EC);
const kFloraBlush = Color(0xFFEDD5DA);
const kFloraDust  = Color(0xFFDCC7C4);
const kFloraSage  = Color(0xFFBDBEAD);
const kFloraRose  = Color(0xFFD996A5); // Primary
const kFloraTaupe = Color(0xFF948685);
const kFloraTeal  = Color(0xFF7BA9BA); // Secondary

ThemeData buildFloraTheme() {
  const primary   = kFloraRose;
  const secondary = kFloraTeal;
  const surface   = kFloraWhite;
  const background= kFloraIvory;

  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    secondary: secondary,
    onSecondary: Colors.white,
    error: const Color(0xFFB00020),
    onError: Colors.white,
    surface: surface,
    onSurface: kFloraTaupe,
    background: background,
    onBackground: kFloraTaupe,
    outline: kFloraSage,
  );

  final display = GoogleFonts.playfairDisplay(
    color: kFloraTaupe,
    fontWeight: FontWeight.w600,
    height: 1.15,
  );
  final text = GoogleFonts.nunitoSans(
    color: kFloraTaupe,
    fontWeight: FontWeight.w500,
    height: 1.20,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,

    textTheme: TextTheme(
      displayLarge:  display.copyWith(fontSize: 44),
      displayMedium: display.copyWith(fontSize: 34),
      titleLarge:    display.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
      titleMedium:   display.copyWith(fontSize: 18),
      bodyLarge:     text.copyWith(fontSize: 16),
      bodyMedium:    text.copyWith(fontSize: 14),
      labelLarge:    text.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      foregroundColor: kFloraTaupe,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: display.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
      toolbarHeight: 64,
    ),

    cardTheme: const CardThemeData(
      color: kFloraWhite,
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: const StadiumBorder(),
        shadowColor: kFloraRose,
        elevation: 2,
        textStyle: GoogleFonts.nunitoSans(
          fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kFloraTaupe,
        side: const BorderSide(color: kFloraRose, width: 1.2),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kFloraWhite,
      hintStyle: text.copyWith(color: kFloraTaupe.withOpacity(.7)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kFloraSage),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kFloraRose, width: 1.4),
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: kFloraSage, thickness: .8, space: 24),
  );
}
