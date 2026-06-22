import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const double size8 = 8;
  static const double size10 = 10;
  static const double size12 = 12;
  static const double size14 = 14;
  static const double size16 = 16;
  static const double size18 = 18;
  static const double size20 = 20;
  static const double size22 = 22;
  static const double size24 = 24;
  static const double size28 = 28;
  static const double size30 = 30;

  static BorderRadius border(double value) => BorderRadius.circular(value);

  static Radius corner(double value) => Radius.circular(value);
}
