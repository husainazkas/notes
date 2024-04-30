import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';
import '../../common/enums.dart';
import '../../common/models/note_item.dart';
import '../utils/utils.dart';

class HomeController extends GetxController {
  final _storage = GetStorage();

  final _notes = <NoteItem>[].obs;
  List<NoteItem> get notes => _notes
      .where((p0) => _searchKeyword.split(' ').any((e) =>
          p0.title?.toLowerCase().contains(e.toLowerCase()) == true ||
          p0.content?.toLowerCase().contains(e.toLowerCase()) == true))
      .sortNote(SortOrder.desc);

  final _isSelecting = false.obs;
  bool get isSelecting => _isSelecting.value;

  final _selectedNotes = <int>[].obs;
  List<int> get selectedNotes => _selectedNotes;

  final searchTextController = TextEditingController();
  late final _searchKeyword = searchTextController.text.obs;
  String get searchKeyword => _searchKeyword.value;

  @override
  void onInit() {
    super.onInit();

    updateNotes();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  void updateNotes() {
    _notes.value = (_storage.read<List>('notes') ?? [])
        .map((e) => NoteItem.fromMap(e))
        .toList();
  }

  void closeSelection() {
    _isSelecting.value = false;
    _selectedNotes.value = [];
  }

  void deleteNotes() {
    for (final i in _selectedNotes) {
      _notes.removeWhere((e) => e.id == i);
    }
    _selectedNotes.clear();
    _isSelecting.value = false;

    unawaited(_storage.write('notes', _notes.map((e) => e.toMap()).toList()));
  }

  void onTypingSearch() {
    _searchKeyword.value = searchTextController.text;
  }

  void onItemTapped(int id) {
    if (_isSelecting.value) {
      if (!_selectedNotes.remove(id)) {
        _selectedNotes.add(id);
      }
    } else {
      Get.toNamed(
        Routes.NOTE_DETAIL,
        arguments: notes.firstWhereOrNull((e) => e.id == id),
      )?.then((value) => updateNotes());
    }
  }

  void onItemLongPressed(int id) {
    if (!_selectedNotes.contains(id)) {
      _isSelecting.value = true;
      _selectedNotes.add(id);
    }
  }
}
