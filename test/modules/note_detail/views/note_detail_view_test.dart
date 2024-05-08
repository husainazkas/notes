import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notes/app/app.dart';
import 'package:notes/app/modules/common/models/note_item.dart';
import 'package:notes/app/modules/home/views/note_card_view.dart';
import 'package:notes/app/modules/note_detail/controllers/note_detail_controller.dart';
import 'package:notes/app/routes/app_pages.dart';

import '../../../core/path_provider_mock_channel.dart';

void main() {
  Get.isLogEnable = false;
  late final GetStorage storage;

  setUpAll(() async {
    setPathProviderMockChannel();

    await GetStorage.init();
    storage = GetStorage();
  });

  setUp(() async {
    await storage.erase();
    Get.reset();
    Get.testMode = true;
  });

  tearDownAll(() async {
    await storage.erase();
  });

  group('Testing `NoteDetailView`', () {
    testWidgets(
      'Verify can navigate to `NoteDetailView` by tap any `NoteCardView` or Add New Note',
      (widgetTester) async {
        await storage.write(
            'notes', _fakeInitialNotes.map((e) => e.toMap()).toList());

        await widgetTester.pumpWidget(const App());

        final cardView = find.byType(NoteCardView).first;
        await widgetTester.tap(cardView);
        await widgetTester.pumpAndSettle();

        expect(Get.currentRoute, Routes.NOTE_DETAIL);

        Get.back();
        await widgetTester.pumpAndSettle();

        final fab = find.byType(FloatingActionButton);
        await widgetTester.tap(fab);
        await widgetTester.pumpAndSettle();

        expect(Get.currentRoute, Routes.NOTE_DETAIL);
      },
    );
    testWidgets(
      'Verify `NoteDetailController` is registered automatically on binding',
      (widgetTester) async {
        await widgetTester.pumpWidget(const App());

        Get.toNamed(Routes.NOTE_DETAIL);
        await widgetTester.pumpAndSettle();

        expect(Get.isRegistered<NoteDetailController>(), isTrue);
      },
    );
    testWidgets(
      'Verify can create a new note but cancel without save',
      (widgetTester) async {
        await widgetTester.pumpWidget(const App());

        Get.toNamed(Routes.NOTE_DETAIL);
        await widgetTester.pumpAndSettle();

        final textField = find.byType(TextField);
        await widgetTester.enterText(textField.first, 'New Title');
        await widgetTester.enterText(textField.last, 'New Content');
        await widgetTester.pumpAndSettle();

        await widgetTester.tap(find.byIcon(Icons.delete));
        await widgetTester.pumpAndSettle();

        await widgetTester.tap(find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Confirm'),
        ));
        await widgetTester.pumpAndSettle();

        final notes = (storage.read<List>('notes') ?? [])
            .map((e) => NoteItem.fromMap(e))
            .toList();

        expect(notes, isEmpty);
      },
    );
    testWidgets(
      'Verify can create a new note and save',
      (widgetTester) async {
        await widgetTester.pumpWidget(const App());

        Get.toNamed(Routes.NOTE_DETAIL);
        await widgetTester.pumpAndSettle();

        final textField = find.byType(TextField);
        await widgetTester.enterText(textField.first, 'New Title');
        await widgetTester.enterText(textField.last, 'New Content');
        await widgetTester.pumpAndSettle();

        await widgetTester.tap(find.byType(BackButton));
        await widgetTester.pumpAndSettle();

        final notes = (storage.read<List>('notes') ?? [])
            .map((e) => NoteItem.fromMap(e))
            .toList();

        expect(notes, isNotEmpty);
      },
    );
    testWidgets(
      'Verify can view an existing note without any updates',
      (widgetTester) async {
        await storage.write(
            'notes', _fakeInitialNotes.map((e) => e.toMap()).toList());

        await widgetTester.pumpWidget(const App());

        Get.toNamed(Routes.NOTE_DETAIL, arguments: _fakeInitialNotes.first);
        await widgetTester.pumpAndSettle();

        final noteDetailController = Get.find<NoteDetailController>();

        expect(
          noteDetailController.titleController.text,
          _fakeInitialNotes.first.title,
        );
        expect(
          noteDetailController.contentController.text,
          _fakeInitialNotes.first.content,
        );

        await widgetTester.tap(find.byType(BackButton));
        await widgetTester.pumpAndSettle();

        final notes = (storage.read<List>('notes') ?? [])
            .map((e) => NoteItem.fromMap(e))
            .toList();

        expect(notes.length, _fakeInitialNotes.length);
        expect(notes.first.id, _fakeInitialNotes.first.id);
        expect(notes.first.title, _fakeInitialNotes.first.title);
        expect(notes.first.content, _fakeInitialNotes.first.content);
        expect(notes.first.updatedAt, _fakeInitialNotes.first.updatedAt);
        expect(notes.first.createdAt, _fakeInitialNotes.first.createdAt);
      },
    );
    testWidgets(
      'Verify can edit an existing note and automatically save',
      (widgetTester) async {
        await storage.write(
            'notes', _fakeInitialNotes.map((e) => e.toMap()).toList());

        await widgetTester.pumpWidget(const App());

        Get.toNamed(Routes.NOTE_DETAIL, arguments: _fakeInitialNotes.first);
        await widgetTester.pumpAndSettle();

        final textField = find.byType(TextField);
        await widgetTester.enterText(textField.first, 'Modified Title');
        await widgetTester.enterText(textField.last, 'Modified Content');
        await widgetTester.pumpAndSettle();

        await widgetTester.tap(find.byType(BackButton));
        await widgetTester.pumpAndSettle();

        final notes = (storage.read<List>('notes') ?? [])
            .map((e) => NoteItem.fromMap(e))
            .toList();

        expect(notes.length, _fakeInitialNotes.length);
        expect(notes.first.id, _fakeInitialNotes.first.id);
        expect(notes.first.title, isNot(_fakeInitialNotes.first.title));
        expect(notes.first.content, isNot(_fakeInitialNotes.first.content));
        expect(notes.first.updatedAt, isNot(_fakeInitialNotes.first.updatedAt));
        expect(notes.first.createdAt, _fakeInitialNotes.first.createdAt);
      },
    );
    testWidgets(
      'Verify can delete existing note',
      (widgetTester) async {
        await storage.write(
            'notes', _fakeInitialNotes.map((e) => e.toMap()).toList());

        await widgetTester.pumpWidget(const App());

        Get.toNamed(Routes.NOTE_DETAIL, arguments: _fakeInitialNotes.first);
        await widgetTester.pumpAndSettle();

        List<NoteItem> notes = (storage.read<List>('notes') ?? [])
            .map((e) => NoteItem.fromMap(e))
            .toList();

        expect(notes.length, _fakeInitialNotes.length);

        await widgetTester.tap(find.byIcon(Icons.delete));
        await widgetTester.pumpAndSettle();

        await widgetTester.tap(find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Confirm'),
        ));
        await widgetTester.pumpAndSettle();

        notes = (storage.read<List>('notes') ?? [])
            .map((e) => NoteItem.fromMap(e))
            .toList();

        expect(notes.length, _fakeInitialNotes.length - 1);
      },
    );
  });
}

final _fakeInitialNotes = [
  NoteItem(
    id: 1,
    title: 'Title 1',
    content: 'Content 1',
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
  ),
  NoteItem(
    id: 2,
    title: 'Title 2',
    content: 'Content 2',
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
  ),
  NoteItem(
    id: 3,
    title: 'Title 3',
    content: 'Content 3',
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
  ),
];
