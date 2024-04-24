import 'package:flutter/material.dart';

abstract final class ColorPalette {
  // The primary color
  static const Color primaryColor = Color(0xFFF83B46);

  // Variant color
  static const Color secondaryColor = Color(0xFFFF6A73);
  static const Color tertiaryColor = Color(0xFF0299FF);
  static const Color alternateLightColor = Color(0xFFE3E7ED);
  static const Color alternateDarkColor = Color(0xFF262D34);

  // Utility color
  static const Color primaryTextLightColor = Color(0xFF14181B);
  static const Color primaryTextDarkColor = Color(0xFFFFFFFF);
  static const Color secondaryTextLightColor = Color(0xFF677681);
  static const Color secondaryTextDarkColor = Color(0xFFA5B0BE);
  static const Color primaryBackgroundLightColor = Color(0xFFF1F4F8);
  static const Color primaryBackgroundDarkColor = Color(0xFF1A1F24);
  static const Color secondaryBackgroundLightColor = Color(0xFFFFFFFF);
  static const Color secondaryBackgroundDarkColor = Color(0xFF0F1316);
}
