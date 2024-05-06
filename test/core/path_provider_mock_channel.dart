import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void setPathProviderMockChannel() {
  TestWidgetsFlutterBinding.ensureInitialized();

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (methodCall) async => './build',
  );
}
