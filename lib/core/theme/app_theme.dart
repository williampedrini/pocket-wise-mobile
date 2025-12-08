import 'package:flutter/material.dart';

class AppColors {
  // Gradient colors
  static const Color gradientStart = Color(0xFF667EEA);
  static const Color gradientEnd = Color(0xFFB794F6);
  
  // Primary colors
  static const Color primary = Color(0xFF667EEA);
  static const Color secondary = Color(0xFFB794F6);
  
  // Background
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  
  // Text colors
  static const Color textPrimary = Color(0xFF1A1D26);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Colors.white;
  
  // Accent colors
  static const Color income = Color(0xFF10B981);
  static const Color expense = Color(0xFFEF4444);
  static const Color incomeChart = Color(0xFFE879F9);
  static const Color expenseChart = Color(0xFF3B82F6);
  
  // Card overlays
  static const Color incomeCardBg = Color(0x33FFFFFF);
  static const Color expenseCardBg = Color(0x33FFFFFF);
}

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.gradientStart, AppColors.gradientEnd],
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        onSurface: AppColors.background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
