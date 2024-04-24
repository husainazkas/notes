import 'package:intl/intl.dart';

import '../../common/enums.dart';
import '../../common/models/note_item.dart';

String formatLastUpdate(DateTime value) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final lastUpdate = DateTime(value.year, value.month, value.day);

  return DateFormat(today == lastUpdate ? 'HH:mm' : 'MMM d').format(value);
}

extension NotesUtil on Iterable<NoteItem> {
  List<NoteItem> sortNote(SortOrder orderBy) {
    return [...this]..sort((a, b) => switch (orderBy) {
          SortOrder.asc => a.updatedAt.compareTo(b.updatedAt),
          SortOrder.desc => b.updatedAt.compareTo(a.updatedAt),
        });
  }
}
