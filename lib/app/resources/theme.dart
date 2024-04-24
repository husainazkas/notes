import 'package:flutter/material.dart';

import 'colors.dart';

abstract final class AppTheme {
  static bool isDarkMode(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }

  static bool isLightMode(BuildContext context) => !isDarkMode(context);

  static ThemeData get lightTheme {
    final ThemeData base = ThemeData.light().copyWith(
      colorScheme: const ColorScheme.light(
        primary: ColorPalette.primaryColor,
        secondary: ColorPalette.secondaryColor,
        tertiary: ColorPalette.tertiaryColor,
        background: ColorPalette.primaryBackgroundLightColor,
        onBackground: ColorPalette.primaryTextLightColor,
        surface: ColorPalette.primaryBackgroundLightColor,
        onSurface: ColorPalette.primaryTextLightColor,
      ),
      primaryColor: ColorPalette.primaryColor,
      scaffoldBackgroundColor: ColorPalette.primaryBackgroundLightColor,
      dialogBackgroundColor: ColorPalette.primaryBackgroundLightColor,
    );
    return _buildThemeData(base);
  }

  static ThemeData get darkTheme {
    final ThemeData base = ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark(
        primary: ColorPalette.primaryColor,
        secondary: ColorPalette.secondaryColor,
        tertiary: ColorPalette.tertiaryColor,
        background: ColorPalette.primaryBackgroundDarkColor,
        onBackground: ColorPalette.primaryTextDarkColor,
        surface: ColorPalette.primaryBackgroundDarkColor,
        onSurface: ColorPalette.primaryTextDarkColor,
      ),
      primaryColor: ColorPalette.primaryColor,
      scaffoldBackgroundColor: ColorPalette.primaryBackgroundDarkColor,
      dialogBackgroundColor: ColorPalette.primaryBackgroundDarkColor,
    );
    return _buildThemeData(base);
  }

  static ThemeData _buildThemeData(ThemeData base) {
    base = base.copyWith(
      textTheme: _buildTextTheme(base),
      inputDecorationTheme: _buildInputDecorationTheme(base),
    );
    return ThemeData(
      brightness: base.brightness,
      colorScheme: base.colorScheme,
      textTheme: base.textTheme,
      inputDecorationTheme: base.inputDecorationTheme,
      primaryColor: base.primaryColor,
      disabledColor: base.disabledColor,
      scaffoldBackgroundColor: base.scaffoldBackgroundColor,
      dividerColor: base.dividerColor,
      unselectedWidgetColor: base.unselectedWidgetColor,
      switchTheme: base.switchTheme,
      radioTheme: base.radioTheme,
      shadowColor: base.shadowColor,
    );
  }

  static TextTheme _buildTextTheme(ThemeData base) {
    return base.textTheme.copyWith().apply(
          bodyColor: base.colorScheme.onBackground,
          displayColor: base.colorScheme.onBackground,
        );
  }

  static InputDecorationTheme _buildInputDecorationTheme(ThemeData base) {
    final halfColor = base.brightness == Brightness.light
        ? ColorPalette.secondaryTextLightColor
        : ColorPalette.secondaryTextDarkColor;
    return InputDecorationTheme(
      hintStyle: TextStyle(
        color: halfColor,
      ),
      prefixIconColor: halfColor,
      suffixIconColor: halfColor,
    );
  }
}
