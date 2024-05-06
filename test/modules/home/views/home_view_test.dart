import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notes/app/app.dart';
import 'package:notes/app/modules/common/models/note_item.dart';
import 'package:notes/app/modules/home/controllers/home_controller.dart';
import 'package:notes/app/modules/home/views/note_card_view.dart';

import '../../../core/path_provider_mock_channel.dart';

void main() {
  Get.testMode = true;
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
  });

  tearDownAll(() async {
    await storage.erase();
  });

  group('Testing `HomeView`:', () {
    void testAppBarState(HomeController homeController, bool isSelecting) {
      // AppBar leading
      final closeButton = find.byType(CloseButton).hitTestable();

      // AppBar actions
      final deleteButton = find.byIcon(Icons.delete);

      if (isSelecting) {
        expect(closeButton, findsOneWidget);

        // AppBar title
        final title = '${switch (homeController.selectedNotes.length) {
          final length => length > 1 ? '$length items' : '$length item',
        }} selected';
        expect(find.text(title), findsOneWidget);

        expect(deleteButton, findsOneWidget);
      } else {
        expect(closeButton, findsNothing);

        // AppBar title
        expect(find.text('Notes'), findsOneWidget);

        expect(deleteButton, findsNothing);
      }
    }

    testWidgets(
      'Verify `HomeController` is registered automatically on binding',
      (widgetTester) async {
        await widgetTester.pumpWidget(const App());

        expect(Get.isRegistered<HomeController>(), isTrue);
      },
    );
    testWidgets(
      'Verify no one note cards are shown when notes are empty',
      (widgetTester) async {
        await widgetTester.pumpWidget(const App());

        final homeController = Get.find<HomeController>();
        expect(homeController.notes, isEmpty);

        expect(find.byType(MasonryGridView), findsNothing);
        expect(find.byType(NoteCardView), findsNothing);
        expect(find.text('You don\'t have a note yet, create one!'),
            findsOneWidget);
      },
    );
    testWidgets(
      'Verify note cards are shown when notes are not empty',
      (widgetTester) async {
        await storage.write(
            'notes', _fakeInitialNotes.map((e) => e.toMap()).toList());

        await widgetTester.pumpWidget(const App());

        final homeController = Get.find<HomeController>();
        expect(homeController.notes, isNotEmpty);

        expect(find.byType(MasonryGridView), findsOneWidget);
        expect(find.byType(NoteCardView), findsWidgets);
      },
    );
    testWidgets(
      'Verify state is not selecting note',
      (widgetTester) async {
        await storage.write(
            'notes', _fakeInitialNotes.map((e) => e.toMap()).toList());

        await widgetTester.pumpWidget(const App());

        final homeController = Get.find<HomeController>();

        expect(homeController.isSelecting, isFalse);
        expect(homeController.selectedNotes, isEmpty);
        testAppBarState(homeController, false);

        final cardView = find.byType(NoteCardView).first;

        // Get `Container` in a `NoteCardView`
        final container = widgetTester.firstWidget<Container>(find.descendant(
          of: cardView,
          matching: find.byType(Container),
        ));

        expect((container.decoration as BoxDecoration?)?.color, isNull);
      },
    );
    testWidgets(
      'Verify state is selecting note then unselect',
      (widgetTester) async {
        await storage.write(
            'notes', _fakeInitialNotes.map((e) => e.toMap()).toList());

        await widgetTester.pumpWidget(const App());

        final cardView = find.byType(NoteCardView).first;

        await widgetTester.longPress(cardView);
        await widgetTester.pumpAndSettle();

        final homeController = Get.find<HomeController>();

        expect(homeController.isSelecting, isTrue);
        expect(homeController.selectedNotes, isNotEmpty);
        testAppBarState(homeController, true);

        // Capture a BuildContext object
        final BuildContext context = widgetTester.element(cardView);

        // Get `Container` in a `NoteCardView`
        Container container =
            widgetTester.firstWidget<Container>(find.descendant(
          of: cardView,
          matching: find.byType(Container),
        ));

        expect(
          (container.decoration as BoxDecoration?)?.color,
          Theme.of(context).colorScheme.primary,
        );

        await widgetTester.tap(cardView);
        await widgetTester.pumpAndSettle();

        expect(homeController.isSelecting, isTrue);
        expect(homeController.selectedNotes, isEmpty);

        // Find again because state and widget properties has been changed
        container = widgetTester.firstWidget<Container>(find.descendant(
          of: find.byType(NoteCardView).first,
          matching: find.byType(Container),
        ));

        expect((container.decoration as BoxDecoration?)?.color, isNull);

        await widgetTester.tap(find.byType(CloseButton));
        await widgetTester.pumpAndSettle();

        expect(homeController.isSelecting, isFalse);
        testAppBarState(homeController, false);
      },
    );
    testWidgets(
      'Verify can delete the selected note',
      (widgetTester) async {
        await storage.write(
            'notes', _fakeInitialNotes.map((e) => e.toMap()).toList());

        await widgetTester.pumpWidget(const App());

        final cardView = find.byType(NoteCardView).first;

        await widgetTester.longPress(cardView);
        await widgetTester.pumpAndSettle();

        final homeController = Get.find<HomeController>();

        expect(homeController.isSelecting, isTrue);
        expect(homeController.selectedNotes, isNotEmpty);
        testAppBarState(homeController, true);

        // Capture a BuildContext object
        final BuildContext context = widgetTester.element(cardView);

        // Get `Container` in a `NoteCardView`
        Container container =
            widgetTester.firstWidget<Container>(find.descendant(
          of: cardView,
          matching: find.byType(Container),
        ));

        expect(
          (container.decoration as BoxDecoration?)?.color,
          Theme.of(context).colorScheme.primary,
        );

        final selectedNote = widgetTester.widget<NoteCardView>(cardView).item;

        await widgetTester.tap(find.byIcon(Icons.delete));
        await widgetTester.pumpAndSettle();

        await widgetTester.tap(find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Confirm'),
        ));
        await widgetTester.pumpAndSettle();

        expect(homeController.isSelecting, isFalse);
        expect(homeController.selectedNotes, isEmpty);
        testAppBarState(homeController, false);

        container = widgetTester.firstWidget<Container>(find.descendant(
          of: cardView,
          matching: find.byType(Container),
        ));

        expect((container.decoration as BoxDecoration?)?.color, null);
        expect(
          homeController.notes.any((e) => e.id == selectedNote.id),
          isFalse,
        );
      },
    );
    testWidgets(
      'Verify filter notes by search keyword',
      (widgetTester) async {
        await storage.write(
            'notes', _fakeInitialNotes.map((e) => e.toMap()).toList());

        await widgetTester.pumpWidget(const App());
        final cardViews = find.byType(NoteCardView);

        final homeController = Get.find<HomeController>();

        // Initial state: show all notes
        expect(homeController.notes.length, _fakeInitialNotes.length);
        expect(cardViews.evaluate().length, _fakeInitialNotes.length);

        // Typing a keyword
        final searchField = find.byType(TextField);
        await widgetTester.enterText(searchField, '1');
        await widgetTester.pumpAndSettle();

        // Filtered by search keyword: only show contains the keyword(s)
        expect(homeController.searchTextController.text, '1');
        expect(homeController.notes.length, 1);
        expect(cardViews.evaluate().length, 1);

        // Clear search keyword
        await widgetTester.tap(find.byIcon(Icons.clear));
        await widgetTester.pumpAndSettle();

        // Search was reset: show all notes again
        expect(homeController.searchTextController.text, isEmpty);
        expect(homeController.notes.length, _fakeInitialNotes.length);
        expect(cardViews.evaluate().length, _fakeInitialNotes.length);
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
