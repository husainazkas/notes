import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../common/models/note_item.dart';
import '../controllers/home_controller.dart';
import '../utils/utils.dart';

class NoteCardView extends GetView<HomeController> {
  const NoteCardView(this.item, {super.key});

  final NoteItem item;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.3,
        ),
        decoration: BoxDecoration(
          color: controller.isSelecting &&
                  controller.selectedNotes.contains(item.id)
              ? Theme.of(context).colorScheme.primary
              : null,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.title case final title when title?.isNotEmpty == true)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    title!,
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              if (item.content case final content
                  when content?.isNotEmpty == true)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      content!,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              Text(
                formatLastUpdate(item.updatedAt),
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
