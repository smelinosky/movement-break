import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'text_styles.dart';

abstract final class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryGreen,
        secondary: AppColors.softGreen,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.backgroundDark,
        onSecondary: AppColors.backgroundDark,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.backgroundDark,
          backgroundColor: AppColors.primaryGreen,
          minimumSize: const Size(double.infinity, 58),
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
