import 'package:flutter/material.dart';
import 'app_colors.dart';

extension AppThemeContext on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get appBackground =>
      isDarkMode ? const Color(0xFF10131A) : AppColors.background;

  Color get appSurface => isDarkMode ? const Color(0xFF1A1F2B) : Colors.white;

  Color get appSurfaceSoft =>
      isDarkMode ? const Color(0xFF242B38) : const Color(0xFFF6F6F8);

  Color get appBorder =>
      isDarkMode ? const Color(0xFF303847) : const Color(0xFFEDEFF4);

  Color get appTextPrimary => isDarkMode ? Colors.white : AppColors.textPrimary;

  Color get appTextSecondary =>
      isDarkMode ? const Color(0xFFB8C0CC) : AppColors.textSecondary;

  Color get appTextLight =>
      isDarkMode ? const Color(0xFF7F8896) : AppColors.textLight;
}
