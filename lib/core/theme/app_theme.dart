import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // ⭐ CẬP NHẬT: Màu chính là darkGreen
      primarySwatch: MaterialColor(0xFF5C603C, {
        50: const Color(0xFFF2F3F0),
        100: const Color(0xFFE0E2DA),
        200: const Color(0xFFC1C5B4),
        300: const Color(0xFFA2A88E),
        400: const Color(0xFF838B68),
        500: AppColors.darkGreen, // Màu chính
        600: const Color(0xFF4A4E30),
        700: const Color(0xFF383B24),
        800: const Color(0xFF262918),
        900: const Color(0xFF14160C),
      }),

      // Màu nền chính
      scaffoldBackgroundColor: AppColors.white,

      // ⭐ THÊM: Color scheme mới
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkGreen,
        brightness: Brightness.light,
        primary: AppColors.darkGreen,
        secondary: AppColors.gray,
        surface: AppColors.white,
        background: AppColors.lightCream,
        error: const Color(0xFFE53E3E),
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.brown,
        onBackground: AppColors.brown,
      ),

      // ⭐ CẬP NHẬT: AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkGreen,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.white),
      ),

      // ⭐ CẬP NHẬT: ElevatedButton theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGreen,
          foregroundColor: AppColors.white,
          elevation: 3,
          shadowColor: AppColors.darkGreen.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),

      // ⭐ THÊM: OutlinedButton theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkGreen,
          side: const BorderSide(color: AppColors.darkGreen, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),

      // ⭐ CẬP NHẬT: InputDecoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightCream,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE53E3E), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE53E3E), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: const TextStyle(
          color: AppColors.brown,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),

      // ⭐ CẬP NHẬT: Text theme
      textTheme: const TextTheme(
        // Tiêu đề lớn
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.brown,
          letterSpacing: -0.5,
        ),
        // Tiêu đề vừa
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.brown,
          letterSpacing: -0.25,
        ),
        // Tiêu đề nhỏ
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.brown,
        ),
        // Body text lớn
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.brown,
          height: 1.5,
        ),
        // Body text vừa
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.brown,
          height: 1.4,
        ),
        // Label text
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.darkGreen,
          letterSpacing: 0.1,
        ),
      ),

      // ⭐ CẬP NHẬT: Card theme
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 4,
        shadowColor: AppColors.brown.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      // ⭐ THÊM: BottomNavigationBar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.darkGreen,
        unselectedItemColor: AppColors.gray,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // ⭐ THÊM: SnackBar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkGreen,
        contentTextStyle: const TextStyle(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      useMaterial3: true,
    );
  }

  // ⭐ THÊM: Helper methods cho màu sắc
  static Color get primaryColor => AppColors.darkGreen;
  static Color get accentColor => AppColors.gray;
  static Color get backgroundColor => AppColors.lightCream;
  static Color get surfaceColor => AppColors.white;
  static Color get textColor => AppColors.brown;

  // ⭐ THÊM: Gradients
  static LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.darkGreen, AppColors.darkGreen.withOpacity(0.8)],
  );

  static LinearGradient get accentGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.gray, AppColors.gray.withOpacity(0.8)],
  );
}
