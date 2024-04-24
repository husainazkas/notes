import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/resources/theme.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  await GetStorage.init();

  runApp(
    GetMaterialApp(
      title: 'Notes',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
    ),
  );
}
