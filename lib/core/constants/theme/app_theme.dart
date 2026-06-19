import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static TextTheme _textTheme({
    required Color primary,
    required Color secondary,
    required Color muted,
  }) {
    return TextTheme(
      displaySmall: TextStyle(
        fontSize: AppTypography.size36,
        fontWeight: AppTypography.bold,
        color: primary,
      ),
      headlineSmall: TextStyle(
        fontSize: AppTypography.size24,
        fontWeight: AppTypography.bold,
        color: primary,
      ),
      titleLarge: TextStyle(
        fontSize: AppTypography.size22,
        fontWeight: AppTypography.semiBold,
        color: primary,
      ),
      titleMedium: TextStyle(
        fontSize: AppTypography.size20,
        fontWeight: AppTypography.bold,
        color: primary,
      ),
      bodyLarge: TextStyle(
        fontSize: AppTypography.size16,
        fontWeight: AppTypography.regular,
        color: primary,
      ),
      bodyMedium: TextStyle(
        fontSize: AppTypography.size14,
        fontWeight: AppTypography.regular,
        color: primary,
      ),
      labelLarge: TextStyle(
        fontSize: AppTypography.size16,
        fontWeight: AppTypography.regular,
        color: muted,
      ),
    );
  }

  static ThemeData get light {
    const onSurface = AppColors.textBlack;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textWhite,
        secondary: AppColors.secondary,
        surface: AppColors.background,
        onSurface: onSurface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _textTheme(
        primary: AppColors.textBlack,
        secondary: AppColors.textSecondary,
        muted: AppColors.textGrey,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: AppTypography.size22,
          fontWeight: AppTypography.semiBold,
          color: AppColors.textBlack,
        ),
        iconTheme: IconThemeData(color: AppColors.textBlack),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.border(AppRadius.size18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        hintStyle: const TextStyle(color: AppColors.textGrey),
        contentPadding: AppSpacing.paddingInput,
        border: OutlineInputBorder(
          borderRadius: AppRadius.border(AppRadius.size16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.border(AppRadius.size16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.border(AppRadius.size16),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.borderLight),
      cardTheme: CardThemeData(
        color: AppColors.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.border(AppRadius.size12),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        onPrimary: AppColors.backgroundDark,
        secondary: AppColors.surfaceDark,
        surface: AppColors.backgroundDark,
        onSurface: AppColors.textWhite,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _textTheme(
        primary: AppColors.textWhite,
        secondary: AppColors.textMutedDark,
        muted: AppColors.textMutedDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: AppTypography.size22,
          fontWeight: AppTypography.semiBold,
          color: AppColors.textWhite,
        ),
        iconTheme: IconThemeData(color: AppColors.textWhite),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.backgroundDark,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.border(AppRadius.size18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primaryDark),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFillDark,
        hintStyle: const TextStyle(color: AppColors.textMutedDark),
        contentPadding: AppSpacing.paddingInput,
        border: OutlineInputBorder(
          borderRadius: AppRadius.border(AppRadius.size16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.border(AppRadius.size16),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.border(AppRadius.size16),
          borderSide: BorderSide(color: AppColors.primaryDark, width: 1.5),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.borderDark),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.border(AppRadius.size12),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryDark,
      ),
    );
  }
}
