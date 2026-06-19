import 'package:flutter/material.dart';

/// Tüm projelerde kullanılabilir tipografi sabitleri.
/// Boyutlar piksel değeriyle adlandırılır: size16 = 16px
abstract final class AppTypography {
  static const double size8 = 8;
  static const double size12 = 12;
  static const double size14 = 14;
  static const double size15 = 15;
  static const double size16 = 16;
  static const double size18 = 18;
  static const double size20 = 20;
  static const double size22 = 22;
  static const double size24 = 24;
  static const double size28 = 28;
  static const double size32 = 32;
  static const double size36 = 36;

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  static TextStyle style({
    required Color color,
    double size = size16,
    FontWeight weight = regular,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
