import 'package:flutter/widgets.dart';

class NoteItem {
  final int id;
  final String? title;
  final String? content;
  final DateTime updatedAt;
  final DateTime createdAt;

  const NoteItem({
    required this.id,
    this.title,
    this.content,
    required this.updatedAt,
    required this.createdAt,
  });

  NoteItem copyWith({
    int? id,
    ValueGetter<String?>? title,
    ValueGetter<String?>? content,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return NoteItem(
      id: id ?? this.id,
      title: title != null ? title() : this.title,
      content: content != null ? content() : this.content,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory NoteItem.fromMap(Map<String, dynamic> map) {
    return NoteItem(
      id: map['id']?.toInt() ?? 0,
      title: map['title'],
      content: map['content'],
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }

  @override
  String toString() {
    return 'NoteItem(id: $id, title: $title, content: $content, updatedAt: $updatedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteItem &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.updatedAt == updatedAt &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        content.hashCode ^
        updatedAt.hashCode ^
        createdAt.hashCode;
  }
}
