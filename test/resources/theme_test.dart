import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:notes/app/app.dart';
import 'package:notes/app/resources/colors.dart';

void main() {
  setUp(() {
    Get.isLogEnable = false;
    Get.testMode = true;
  });

  group('Testing `ThemeData`:', () {
    testWidgets(
      'Verify can switch `ThemeMode`',
      (widgetTester) async {
        await widgetTester.pumpWidget(const App());

        for (final mode in ThemeMode.values) {
          if (mode == ThemeMode.system) {
            // Ignored because it may be a dark or light that
            // already covered from another enum members
            continue;
          }

          if (Get.isDarkMode) {
            Get.changeThemeMode(ThemeMode.light);
            await widgetTester.pumpAndSettle();
            expect(Get.isDarkMode, isFalse);
          } else {
            Get.changeThemeMode(ThemeMode.dark);
            await widgetTester.pumpAndSettle();
            expect(Get.isDarkMode, isTrue);
          }
        }
      },
    );
    testWidgets(
      'Verify custom theme is set correctly in `ThemeMode.dark`',
      (widgetTester) async {
        await widgetTester.pumpWidget(const App());

        final theme = Get.theme;
        expect(theme.primaryColor, ColorPalette.primaryColor);
        expect(theme.colorScheme.primary, ColorPalette.primaryColor);
        expect(theme.colorScheme.secondary, ColorPalette.secondaryColor);
        expect(theme.colorScheme.tertiary, ColorPalette.tertiaryColor);
        expect(
          theme.colorScheme.background,
          ColorPalette.primaryBackgroundDarkColor,
        );
        expect(
          theme.colorScheme.onBackground,
          ColorPalette.primaryTextDarkColor,
        );
        expect(
          theme.colorScheme.surface,
          ColorPalette.primaryBackgroundDarkColor,
        );
        expect(theme.colorScheme.onSurface, ColorPalette.primaryTextDarkColor);
        expect(
          theme.scaffoldBackgroundColor,
          ColorPalette.primaryBackgroundDarkColor,
        );
        expect(
          theme.dialogBackgroundColor,
          ColorPalette.primaryBackgroundDarkColor,
        );

        for (final e in [
          theme.textTheme.bodyLarge,
          theme.textTheme.bodyMedium,
          theme.textTheme.bodySmall,
          theme.textTheme.displayLarge,
          theme.textTheme.displayMedium,
          theme.textTheme.displaySmall,
          theme.textTheme.headlineLarge,
          theme.textTheme.headlineMedium,
          theme.textTheme.headlineSmall,
          theme.textTheme.labelLarge,
          theme.textTheme.labelMedium,
          theme.textTheme.labelSmall,
          theme.textTheme.titleLarge,
          theme.textTheme.titleMedium,
          theme.textTheme.titleSmall,
          theme.textTheme.titleSmall,
        ]) {
          expect(e?.color, ColorPalette.primaryTextDarkColor);
        }

        for (final e in [
          theme.inputDecorationTheme.hintStyle?.color,
          theme.inputDecorationTheme.prefixIconColor,
          theme.inputDecorationTheme.suffixIconColor,
        ]) {
          expect(e, ColorPalette.secondaryTextDarkColor);
        }
      },
    );
    testWidgets(
      'Verify custom theme is set correctly in `ThemeMode.light`',
      (widgetTester) async {
        await widgetTester.pumpWidget(const App());

        // Need to switch first because
        // selected `ThemeMode` in `App` is `ThemeMode.dark`
        Get.changeThemeMode(ThemeMode.light);
        await widgetTester.pumpAndSettle();

        final theme = Get.theme;
        expect(theme.primaryColor, ColorPalette.primaryColor);
        expect(theme.colorScheme.primary, ColorPalette.primaryColor);
        expect(theme.colorScheme.secondary, ColorPalette.secondaryColor);
        expect(theme.colorScheme.tertiary, ColorPalette.tertiaryColor);
        expect(
          theme.colorScheme.background,
          ColorPalette.primaryBackgroundLightColor,
        );
        expect(
          theme.colorScheme.onBackground,
          ColorPalette.primaryTextLightColor,
        );
        expect(
          theme.colorScheme.surface,
          ColorPalette.primaryBackgroundLightColor,
        );
        expect(theme.colorScheme.onSurface, ColorPalette.primaryTextLightColor);
        expect(
          theme.scaffoldBackgroundColor,
          ColorPalette.primaryBackgroundLightColor,
        );
        expect(
          theme.dialogBackgroundColor,
          ColorPalette.primaryBackgroundLightColor,
        );

        for (final e in [
          theme.textTheme.bodyLarge,
          theme.textTheme.bodyMedium,
          theme.textTheme.bodySmall,
          theme.textTheme.displayLarge,
          theme.textTheme.displayMedium,
          theme.textTheme.displaySmall,
          theme.textTheme.headlineLarge,
          theme.textTheme.headlineMedium,
          theme.textTheme.headlineSmall,
          theme.textTheme.labelLarge,
          theme.textTheme.labelMedium,
          theme.textTheme.labelSmall,
          theme.textTheme.titleLarge,
          theme.textTheme.titleMedium,
          theme.textTheme.titleSmall,
          theme.textTheme.titleSmall,
        ]) {
          expect(e?.color, ColorPalette.primaryTextLightColor);
        }

        for (final e in [
          theme.inputDecorationTheme.hintStyle?.color,
          theme.inputDecorationTheme.prefixIconColor,
          theme.inputDecorationTheme.suffixIconColor,
        ]) {
          expect(e, ColorPalette.secondaryTextLightColor);
        }
      },
    );
  });
}
