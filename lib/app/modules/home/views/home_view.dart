import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../common/views/hide_focus_view.dart';
import '../controllers/home_controller.dart';
import 'note_card_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return HideFocus(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: Obx(
            () => Visibility(
              visible: controller.isSelecting,
              child: CloseButton(
                onPressed: () => controller.closeSelection(),
              ),
            ),
          ),
          title: Obx(
            () => Text(switch (controller.isSelecting) {
              true => '${switch (controller.selectedNotes.length) {
                  final length => length > 1 ? '$length items' : '$length item',
                }} selected',
              false => 'Notes',
            }),
          ),
          centerTitle: true,
          actions: [
            Obx(
              () => Visibility(
                visible: controller.isSelecting,
                child: IconButton(
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
                      controller.deleteNotes();
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => TextField(
                  controller: controller.searchTextController,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.background,
                    filled: true,
                    hintText: 'Search notes',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .hintStyle
                          ?.color,
                    ),
                    suffixIcon: controller.searchKeyword.isNotEmpty
                        ? InkWell(
                            onTap: () =>
                                controller.searchTextController.clear(),
                            child: Icon(
                              Icons.clear,
                              color: Theme.of(context)
                                  .inputDecorationTheme
                                  .hintStyle
                                  ?.color,
                            ),
                          )
                        : null,
                  ),
                  onChanged: (_) => controller.onTypingSearch(),
                ),
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.notes.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'You don\'t have a note yet, create one!',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return MasonryGridView.builder(
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            padding: const EdgeInsets.all(16.0),
            itemCount: controller.notes.length,
            itemBuilder: (context, itemsIndex) {
              final item = controller.notes[itemsIndex];
              return InkWell(
                onTap: () => controller.onItemTapped(item.id),
                onLongPress: () => controller.onItemLongPressed(item.id),
                child: NoteCardView(item),
              );
            },
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.NOTE_DETAIL)
                ?.then((value) => controller.updateNotes());
            controller.closeSelection();
          },
          shape: const CircleBorder(),
          foregroundColor: Theme.of(context).colorScheme.onBackground,
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }
}
