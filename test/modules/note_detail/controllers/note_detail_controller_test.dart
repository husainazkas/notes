import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notes/app/modules/common/models/note_item.dart';
import 'package:notes/app/modules/note_detail/controllers/note_detail_controller.dart';

import '../../../core/path_provider_mock_channel.dart';

void main() {
  late final GetStorage storage;
  late NoteDetailController noteDetailController;

  setUpAll(() async {
    setPathProviderMockChannel();

    await GetStorage.init();
    storage = GetStorage();
  });

  setUp(() async {
    await storage.erase();
    Get.reset();
    Get.isLogEnable = false;
    Get.testMode = true;

    noteDetailController = NoteDetailController();
  });

  tearDownAll(() async {
    await storage.erase();
  });

  group('Testing `NoteDetailController`', () {
    test('Should success pass and retrieve `NoteItem` as args', () async {
      // Inject navigation args which is needed in `NoteDetailController`
      Get.routing.args = _fakeInitialNote;

      expect(noteDetailController.data, isNotNull);
      expect(noteDetailController.isEditing, isTrue);

      expect(noteDetailController.titleController.text, _fakeInitialNote.title);
      expect(noteDetailController.contentController.text,
          _fakeInitialNote.content);
    });
    test(
      'Should success edit and save note update',
      () async {
        await storage.write('notes', [_fakeInitialNote.toMap()]);

        List<NoteItem> notes = (storage.read<List>('notes') ?? [])
            .map((e) => NoteItem.fromMap(e))
            .toList();

        expect(notes.length, 1);
        expect(notes.single, _fakeInitialNote);

        // Inject navigation args which is needed in `NoteDetailController`
        Get.routing.args = notes.single;

        // Will run `NoteDetailController` then onInit will be triggered
        Get.put(noteDetailController);

        final titleController = noteDetailController.titleController;
        final contentController = noteDetailController.contentController;

        titleController.text = 'Editted Title';
        contentController.text = 'Editted Content';

        // To make sure property `NoteItem.updatedAt` will change after delay
        await Future.delayed(const Duration(milliseconds: 1000));

        noteDetailController.save();

        // Needed because `save` function is actually has an async process
        await Future.delayed(const Duration(milliseconds: 500));

        notes = (storage.read<List>('notes') ?? [])
            .map((e) => NoteItem.fromMap(e))
            .toList();

        expect(notes.length, 1);
        expect(notes.single.id, _fakeInitialNote.id);
        expect(notes.single.title, isNot(_fakeInitialNote.title));
        expect(notes.single.content, isNot(_fakeInitialNote.content));
        expect(notes.single.updatedAt, isNot(_fakeInitialNote.updatedAt));
        expect(notes.single.createdAt, _fakeInitialNote.createdAt);
      },
    );
    test('Should success delete note', () async {
      await storage.write('notes', [_fakeInitialNote.toMap()]);

      List<NoteItem> notes = (storage.read<List>('notes') ?? [])
          .map((e) => NoteItem.fromMap(e))
          .toList();

      expect(notes.length, 1);

      // Inject navigation args which is needed in `NoteDetailController`
      Get.routing.args = notes.single;

      // Will run `NoteDetailController` then onInit will be triggered
      Get.put(noteDetailController);

      noteDetailController.delete();

      // Needed because `save` function is actually has an async process
      await Future.delayed(const Duration(milliseconds: 500));

      notes = (storage.read<List>('notes') ?? [])
          .map((e) => NoteItem.fromMap(e))
          .toList();

      expect(notes, isEmpty);
    });
  });
}

final _fakeInitialNote = NoteItem(
  id: 1,
  title: 'Title',
  content: 'Content',
  updatedAt: DateTime.now(),
  createdAt: DateTime.now(),
);
