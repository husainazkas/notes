import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/views/hide_focus_view.dart';
import '../controllers/note_detail_controller.dart';

class NoteDetailView extends GetView<NoteDetailController> {
  const NoteDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) controller.save();
      },
      child: HideFocus(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(controller.isEditing ? 'Edit Note' : 'New Note'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () async {
                  final response = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Are you sure to delete?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  );

                  if (response == true) {
                    controller.delete();
                  }
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TextField(
                controller: controller.titleController,
                decoration: const InputDecoration(
                  enabledBorder: InputBorder.none,
                  hintText: 'Title',
                ),
              ),
              const SizedBox(height: 16.0),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Text(
                      DateFormat('MMMM dd HH:mm')
                          .format(controller.data?.updatedAt ?? DateTime.now()),
                      style: const TextStyle(fontSize: 10.0),
                    ),
                    VerticalDivider(
                      thickness: .5,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    Obx(
                      () => Text(
                        switch (controller.content.length) {
                          final length =>
                            '$length character${length > 1 ? 's' : ''}'
                        },
                        style: const TextStyle(fontSize: 10.0),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: controller.contentController,
                onChanged: (_) => controller.onTypingContent(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start typing...',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
