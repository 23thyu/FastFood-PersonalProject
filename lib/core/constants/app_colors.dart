import 'package:flutter/material.dart';

class AppColors {
  // ⭐ SỬA LẠI: Màu từ bảng màu "EAT CLEAN" đúng theo thiết kế
  static const Color brown = Color.fromARGB(
    255,
    35,
    33,
    33,
  ); // #74493D - Text color
  static const Color gray = Color.fromARGB(
    255,
    156,
    156,
    156,
  ); // #D26426 - Secondary color
  static const Color darkGreen = Color(0xFFCE181B); // #CE181B - Primary color
  static const Color lightCream = Color.fromARGB(
    255,
    243,
    243,
    243,
  ); // #FFF7ED - Background
  static const Color white = Color(0xFFFFFFFF); // #FFFFFF - Surface
  static const Color backgroundGreen = Color(0xFF46D375); // #46D375 - Accent

  // ⭐ THÊM: Màu cho các trạng thái khác nhau
  static const Color lightGreen = Color(0xFFE8F5E8); // Light green tint
  static const Color redAccent = Color(0xFFFF3B30); // Red cho Special Offer
  static const Color greyLight = Color(0xFFF8F9FA); // Light grey
  static const Color greyMedium = Color(0xFFE9ECEF); // Medium grey
  static const Color textSecondary = Color.fromARGB(
    255,
    113,
    118,
    122,
  ); // Secondary text

  // Màu chính của ứng dụng
  static const Color primary = darkGreen;
  static const Color secondary = gray;
  static const Color background = lightCream;
  static const Color surface = white;
  static const Color accent = gray;
}
