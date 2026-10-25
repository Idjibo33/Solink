import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTextStyles {
  static TextStyle get heading =>
      GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold);

  static TextStyle get title =>
      GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold);

  static TextStyle get body =>
      GoogleFonts.roboto(fontSize: 14, color: Colors.black54);

  static TextStyle get caption =>
      GoogleFonts.roboto(fontSize: 12, color: Colors.black45);

  static TextStyle get button =>
      GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold);

  static TextStyle get hint =>
      GoogleFonts.roboto(fontSize: 14, color: Colors.black38);
}

ThemeData buildAppTheme(Color seedColor) {
  final colorScheme = ColorScheme.fromSeed(seedColor: seedColor);
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.robotoTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: AppTextStyles.title.copyWith(
        color: Colors.black87,
        fontSize: 18,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.04),
      hintStyle: AppTextStyles.hint,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(24),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(24),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        borderRadius: BorderRadius.circular(24),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.error),
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: AppTextStyles.button,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: AppTextStyles.button,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
