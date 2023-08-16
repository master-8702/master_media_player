import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:mastermediaplayer/features/file_explorer/common/select_storage.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/file_explorer_controller.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';

class SongExplorerHeader extends StatelessWidget {
  const SongExplorerHeader({
    super.key,
    required this.controller,
    required this.selectedSongs,
  });

  final FileExplorerController controller;
  final RxList<String> selectedSongs;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // menu and back button

      SizedBox(
        height: 60,
        width: 60,
        child: NeumorphicContainer(
          child: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_rounded,
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 5,
      ),

      // here by listening to the changes from currentDirectory value notifier
      // we will update the current Directory or folder name in the title of the page
      Expanded(
        child: Obx(
          () {
            return TextScroll(
                velocity:
                    const Velocity(pixelsPerSecond: Offset(30, 30)),
                Utilities.basename(controller.currentDir.value) != '0'
                    ? Utilities.basename(controller.currentDir.value)
                    : 'Internal Storage',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontSize: 20));
          },
        ),
      ),
      // this music player app is developed by master
      const SizedBox(
        width: 5,
      ),

      SizedBox(
        width: 60,
        height: 60,
        child: NeumorphicContainer(
          child: PopupMenuButton(
              position: PopupMenuPosition.under,
              icon: const Icon(
                Icons.more_vert,
              ),
              onSelected: (selectedValue) {
                if (selectedValue == 'Select Songs') {
                  Get.back(result: selectedSongs);
                } else if (selectedValue == 'Change Storage') {
                  selectStorage(context, controller);
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                      value: 'Select Songs',
                      child: Text('Select Songs')),
                  PopupMenuItem(
                      value: 'Change Storage',
                      child: Text('Change Storage'))
                ];
              }),
        ),
      ),
    ]);
  }
}
