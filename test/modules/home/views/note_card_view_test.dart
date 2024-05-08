import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notes/app/app.dart';
import 'package:notes/app/modules/common/models/note_item.dart';
import 'package:notes/app/modules/home/utils/utils.dart';
import 'package:notes/app/modules/home/views/note_card_view.dart';

import '../../../core/path_provider_mock_channel.dart';

void main() {
  late final GetStorage storage;

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
  });

  tearDownAll(() async {
    await storage.erase();
  });

  group('Testing `NoteCardView`:', () {
    testWidgets(
      'Verify show only existed property in card',
      (widgetTester) async {
        await storage.write(
            'notes', _fakeInitialNotes.map((e) => e.toMap()).toList());

        await widgetTester.pumpWidget(const App());

        final cardViews = find.byType(NoteCardView);
        for (final cardViewElement in cardViews.evaluate().indexed) {
          final cardViewFinder = cardViews.at(cardViewElement.$1);
          final widget = cardViewElement.$2.widget as NoteCardView;
          final texts = widgetTester.widgetList<Text>(find.descendant(
            of: cardViewFinder,
            matching: find.byType(Text),
          ));

          bool titleChecked = false;
          bool contentChecked = false;
          for (final text in texts) {
            if (widget.item.title case final title
                when title?.isNotEmpty == true && !titleChecked) {
              expect(text.data, title);
              titleChecked = true;
              continue;
            }
            if (widget.item.content case final content
                when content?.isNotEmpty == true && !contentChecked) {
              expect(text.data, content);
              contentChecked = true;
              continue;
            }
            expect(text.data, formatLastUpdate(widget.item.updatedAt));
          }
        }
      },
    );
  });
}

final _fakeInitialNotes = [
  NoteItem(
    id: 1,
    title: 'Title',
    content: null,
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
  ),
  NoteItem(
    id: 2,
    title: null,
    content: 'Content',
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
  ),
];
