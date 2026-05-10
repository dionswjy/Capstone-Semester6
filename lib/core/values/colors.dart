import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0040A1);
  static const Color primaryContainer = Color(0xFF0056D2);
  static const Color onPrimary = Colors.white;
  static const Color secondary = Color(0xFF006875);
  static const Color secondaryContainer = Color(0xFF00E3FD);
  static const Color surface = Color(0xFFF9F9FC);
  static const Color onSurface = Color(0xFF1A1C1E);
  static const Color onSurfaceVariant = Color(0xFF424654);
  static const Color outline = Color(0xFF737785);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color background = Color(0xFFF9F9FC);
  static const Color primaryFixed = Color(0xFFD8E2FF);
  static const Color secondaryFixed = Color(0xFFCCF0F4);
  static const Color onSecondaryContainer = Color(0xFF004F57);
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF3F3F6),
      Color(0xFFF9F9FC),
    ],
  );
}
