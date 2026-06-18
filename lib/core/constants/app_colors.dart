import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan renk paleti.
abstract final class AppColors {
  // ── Marka yeşilleri (birbirine yakın tonlar tek isimde) ──
  static const Color primary = Color(0xFF04764E);
  static const Color primaryDark = Color(0xFF0F7B4D);
  static const Color primaryLight = Color(0xFF0A8A5B);
  static const Color primarySurface = Color(0xFFDDEDE6);
  static const Color primaryTint = Color(0x1F04764E);
  static const Color primaryDisabled = Color(0x9904764E);

  /// Geriye dönük uyumluluk
  static const Color primaryColor = primary;

  // ── Nötr / arka plan ──
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color background = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFEDEDED);
  static const Color transparent = Color(0x00000000);

  static const Color backgroundColor = background;
  static const Color secondaryColor = secondary;

  // ── Metin ──
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0x8A000000);
  static const Color textMuted = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Kenarlık & yüzey ──
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0x1F000000);
  static const Color inputFill = Color(0xFFF5F5F5);
  static const Color surfaceMuted = Color(0xFFEEEEEE);
  static const Color shadow = Color(0x14000000);

  // ── Turuncu / puan rozeti (0xFFFF9333 ≈ 0xFFFF9A3D) ──
  static const Color accentOrange = Color(0xFFFF9333);

  // ── Yıldız / rating ──
  static const Color star = Color(0xFFFFC107);

  // ── Hata / silme ──
  static const Color error = Color(0xFFF44336);
  static const Color errorAccent = Color(0xFFFF5252);

  // ── Auth & sosyal ──
  static const Color facebook = Color(0xFF1877F2);
  static const Color createAccountBackground = Color(0xFFF6DBB3);

  static const Color facebookColor = facebook;
  static const Color createAccountBackgroundColor = createAccountBackground;
}
