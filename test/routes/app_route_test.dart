import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:notes/app/app.dart';
import 'package:notes/app/routes/app_pages.dart';

void main() {
  setUp(() {
    Get.isLogEnable = false;
    Get.testMode = true;
  });

  group('Testing app route configuration:', () {
    testWidgets(
      'Should success navigate to any routes available',
      (widgetTester) async {
        await widgetTester.pumpWidget(const App());

        expect(Get.currentRoute, Routes.HOME);

        for (final route in const [Routes.HOME, Routes.NOTE_DETAIL]) {
          Get.toNamed(route);
          await widgetTester.pumpAndSettle();

          expect(Get.currentRoute, route);
        }
      },
    );
  });
}
