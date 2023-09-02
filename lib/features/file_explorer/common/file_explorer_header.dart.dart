import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:mastermediaplayer/features/file_explorer/common/select_storage.dart';
import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';
import 'package:mastermediaplayer/utilities/file_and_directory_utilities.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/file_explorer_controller.dart';

class FileExplorerHeader extends StatelessWidget {
  /// This custom widget will be used as a header for all types of file explorer pages,
  /// to display and manage back button, current directory name and storage selection.

  const FileExplorerHeader({super.key, required this.controller});
  final FileExplorerController controller;

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
              size: 30,
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
                velocity: const Velocity(pixelsPerSecond: Offset(30, 30)),
                FileAndDirectoryUtilities .basename(controller.currentDir.value) != '0'
                    ? FileAndDirectoryUtilities.basename(controller.currentDir.value)
                    : 'Internal Storage',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontSize: 20));
          },
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      SizedBox(
        height: 60,
        width: 60,
        child: NeumorphicContainer(
          child: TextButton(
            onPressed: () {
              selectStorage(context, controller);
            },
            child: const Icon(
              Icons.sd_storage,
              size: 30,
            ),
          ),
        ),
      ),
    ]);
  }
}
