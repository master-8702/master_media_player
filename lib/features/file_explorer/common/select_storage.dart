import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/features/file_explorer/presentation/file_explorer_controller.dart';
import 'package:mastermediaplayer/utilities/file_and_directory_utilities.dart';

void selectStorage(BuildContext context, FileExplorerController controller) {
  /// This custom method will show a dialog with a list of available storage devices (secondary memories)
  ///  in the device.
  ///  And by selecting one we can update the current Directory List and surf
  /// the new selected storage device.

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: FutureBuilder<List<FileSystemEntity>>(
        future: controller.getStorageList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<FileSystemEntity> storageList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Storage List'),
                const SizedBox(
                  height: 10,
                ),
                // the spread operator (three dots) will add the below list returned from map object
                // to the above to widget lists
                ...storageList
                    .map((e) => Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: TextButton(
                                  child: Text(
                                    FileAndDirectoryUtilities.basename(e) == '0'
                                        ? 'Internal Storage'
                                        : FileAndDirectoryUtilities.basename(e),
                                  ),
                                  onPressed: () {
                                    controller.currentDir.value =
                                        e as Directory;
                                    Get.back();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ))
                    .toList()
              ]),
            );
          }
          return const AlertDialog(
            content: CircularProgressIndicator(),
          );
        },
      ),
    ),
  );
}
