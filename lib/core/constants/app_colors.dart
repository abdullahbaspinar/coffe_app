import 'package:flutter/material.dart';

abstract final class AppColors {
  
  static const Color primary = Color(0xFF04764E);
  static const Color background = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textBlack = Color(0xFF1B1B1B);
  static const Color textGrey = Color(0xFF777777);

  static const Color primaryDark = Color(0xFF2ECC8A);
  static const Color backgroundDark = Color(0xFF0F1412);
  static const Color surfaceDark = Color(0xFF1A211E);
  static const Color textMutedDark = Color(0xFFB0B0B0);
  static const Color borderDark = Color(0xFF2A332F);
  static const Color inputFillDark = Color(0xFF1A211E);

  static const Color buttonBackground = Color(0xFFF6DBB3);
  static const Color star = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color errorAccent = Color(0xFFFF5252);

  static const Color secondary = Color(0xFFEDEDED);
  static const Color border = Color(0xFFE0E0E0);
  static const Color inputFill = Color(0xFFF5F5F5);
  static const Color surfaceMuted = Color(0xFFEEEEEE);
  static const Color primaryLight = Color(0xFF0A8A5B);
  static const Color primarySurface = Color(0xFFDDEDE6);
  static const Color accentOrange = Color(0xFFFF9333);
  static const Color primaryTint = Color(0x1F04764E);
  static const Color primaryDisabled = Color(0x9904764E);
  static const Color borderLight = Color(0x1F000000);
  static const Color shadow = Color(0x14000000);
  static const Color textSecondary = Color(0x8A000000);
  static const Color facebook = Color(0xFF1877F2);

  static const Color primaryColor = primary;
  static const Color backgroundColor = background;
  static const Color white = textWhite;
  static const Color textPrimary = textBlack;
  static const Color textMuted = textGrey;
  static const Color secondaryColor = secondary;
  static const Color createAccountBackground = buttonBackground;
  static const Color createAccountBackgroundColor = buttonBackground;
  static const Color facebookColor = facebook;
  static const Color textDisabled = textGrey;
  static const Color textOnPrimary = textWhite;
}

extension AppColorsContext on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get appPrimary =>
      isDarkMode ? AppColors.primaryDark : AppColors.primary;

  Color get appBackground =>
      isDarkMode ? AppColors.backgroundDark : AppColors.background;

  Color get appSurface =>
      isDarkMode ? AppColors.surfaceDark : AppColors.background;

  Color get appTextPrimary =>
      isDarkMode ? AppColors.textWhite : AppColors.textBlack;

  Color get appTextMuted =>
      isDarkMode ? AppColors.textMutedDark : AppColors.textGrey;

  Color get appBorder => isDarkMode ? AppColors.borderDark : AppColors.border;

  Color get appInputFill =>
      isDarkMode ? AppColors.inputFillDark : AppColors.inputFill;

  Color get appSecondary =>
      isDarkMode ? AppColors.surfaceDark : AppColors.secondary;

  Color get appPrimarySurface =>
      isDarkMode ? AppColors.surfaceDark : AppColors.primarySurface;

  Color get appPrimaryTint => isDarkMode
      ? AppColors.primaryDark.withValues(alpha: 0.15)
      : AppColors.primaryTint;
}
