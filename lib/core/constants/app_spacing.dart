import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s18 = 18;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s30 = 30;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s60 = 60;

  static const EdgeInsets padding12 = EdgeInsets.all(s12);
  static const EdgeInsets padding16 = EdgeInsets.all(s16);
  static const EdgeInsets padding20 = EdgeInsets.all(s20);
  static const EdgeInsets padding24 = EdgeInsets.all(s24);
  static const EdgeInsets padding30 = EdgeInsets.all(s30);

  static const EdgeInsets paddingH16 = EdgeInsets.symmetric(horizontal: s16);
  static const EdgeInsets paddingH20 = EdgeInsets.symmetric(horizontal: s20);
  static const EdgeInsets paddingH24 = EdgeInsets.symmetric(horizontal: s24);

  static const EdgeInsets paddingV12 = EdgeInsets.symmetric(vertical: s12);
  static const EdgeInsets paddingV20 = EdgeInsets.symmetric(vertical: s20);

  static const EdgeInsets paddingInput = EdgeInsets.symmetric(
    horizontal: s16,
    vertical: s18,
  );
}
