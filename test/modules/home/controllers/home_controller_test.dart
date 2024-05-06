import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notes/app/modules/common/models/note_item.dart';
import 'package:notes/app/modules/home/controllers/home_controller.dart';

import '../../../core/path_provider_mock_channel.dart';

void main() {
  Get.testMode = true;
  Get.isLogEnable = false;
  late final GetStorage storage;
  late HomeController homeController;

  setUpAll(() async {
    setPathProviderMockChannel();

    await GetStorage.init();
    storage = GetStorage();
  });

  setUp(() async {
    await storage.erase();
    Get.reset();

    homeController = HomeController();
  });

  tearDownAll(() async {
    await storage.erase();
  });

  group('Testing `HomeController:`', () {
    test('Should success read empty list of `NoteItem` from storage when init',
        () async {
      // Will run `HomeController` then onInit will be triggered
      Get.put(homeController);
      expect(homeController.notes, isEmpty);
    });
    test(
        'Should success read and parse list of `NoteItem` from storage when init',
        () async {
      await storage.write(
          'notes', _fakeInitialNotes.map((e) => e.toMap()).toList());
      // Will run `HomeController` then onInit will be triggered
      Get.put(homeController);
      expect(homeController.notes, isNotEmpty);
    });
    test('Should success read update list of `NoteItem` from storage',
        () async {
      // Will run `HomeController` then onInit will be triggered
      Get.put(homeController);
      expect(homeController.notes, isEmpty);

      await storage.write(
          'notes', _fakeInitialNotes.map((e) => e.toMap()).toList());

      homeController.updateNotes();
      expect(homeController.notes, isNotEmpty);
    });
  });
}

final _fakeInitialNotes = [
  NoteItem(
    id: 1,
    title: 'Title',
    content: 'Content',
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
  ),
  NoteItem(
    id: 2,
    title: 'Title',
    content: 'Content',
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
  ),
  NoteItem(
    id: 3,
    title: 'Title',
    content: 'Content',
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
  ),
];
