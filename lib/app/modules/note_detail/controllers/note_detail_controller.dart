import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/models/note_item.dart';

class NoteDetailController extends GetxController {
  final _storage = GetStorage();

  NoteItem? get data => Get.arguments;

  bool get isEditing => data != null;

  late final titleController = TextEditingController(text: data?.title);
  late final contentController = TextEditingController(text: data?.content);

  late final _contentCount = contentController.text.length.obs;
  int get contentCount => _contentCount.value;

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }

  void delete() {
    if (isEditing) {
      final notes = (_storage.read<List>('notes') ?? [])
          .map((e) => NoteItem.fromMap(e))
          .toList()
        ..removeWhere((e) => e.id == data!.id);

      unawaited(_storage.write('notes', notes.map((e) => e.toMap()).toList()));
    }
    Get.back();
  }

  void save() {
    List<NoteItem> notes = (_storage.read<List>('notes') ?? [])
        .map((e) => NoteItem.fromMap(e))
        .toList();
    final now = DateTime.now();

    if (isEditing) {
      if ((titleController.text, contentController.text) case final result
          when result.$1 != data!.title || result.$2 != data!.content) {
        notes = notes.map((e) {
          if (e.id == data!.id) {
            return data!.copyWith(
              id: e.id,
              title: () => result.$1,
              content: () => result.$2,
              updatedAt: now,
              createdAt: e.createdAt,
            );
          }
          return e;
        }).toList();
      }
    } else {
      if (titleController.text.isNotEmpty ||
          contentController.text.isNotEmpty) {
        final sortedNotes = notes..sort((a, b) => a.id.compareTo(b.id));
        final id = (sortedNotes.lastOrNull?.id ?? 0) + 1;

        final result = NoteItem(
          id: id,
          title: titleController.text,
          content: contentController.text,
          updatedAt: now,
          createdAt: now,
        );

        notes = [...notes, result];
      }
    }

    unawaited(_storage.write('notes', notes.map((e) => e.toMap()).toList()));
  }

  void onTypingContent() {
    _contentCount.value = contentController.text.length;
  }
}
