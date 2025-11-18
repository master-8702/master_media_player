import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/Constants/file_extensions.dart';
import 'package:mastermediaplayer/features/file_explorer/common/can_not_load_data.dart';
import 'package:mastermediaplayer/features/file_explorer/common/file_search_text_field.dart';
import 'package:mastermediaplayer/features/file_explorer/common/loading_data.dart';
import 'package:mastermediaplayer/features/file_explorer/common/no_files_in_this_folder.dart';
import 'package:mastermediaplayer/features/file_explorer/common/song_explorer_header.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/file_explorer_controller.dart';
import 'package:mastermediaplayer/common/models/song_model.dart';
import 'package:mastermediaplayer/utilities/file_and_directory_utilities.dart';
import 'package:mastermediaplayer/utilities/file_metadata.dart';
import 'package:mastermediaplayer/routing/app_routes.dart';

// this class is going to help us in basic file(music) exploring from the available storage devices in the phone
// and it will be used to select single and/or multiple audio files from the storage in order to add them to our playlists.
class SelectableSongExplorerScreen extends StatefulWidget {
  const SelectableSongExplorerScreen({Key? key}) : super(key: key);

  @override
  State<SelectableSongExplorerScreen> createState() =>
      _SelectableSongExplorerScreenState();
}

class _SelectableSongExplorerScreenState
    extends State<SelectableSongExplorerScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<FileExplorerController>(
          init: FileExplorerController(fileTypes: kSupportedAudioFormats),
          builder: (controller) {
            // overriding the back button using [PopScope]
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                // handling the back button
                controller.onPopInvokedWithResultCallBack(
                    didPop, context, result);
              },
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: [
                    SongExplorerHeader(
                        controller: controller,
                        selectedSongs: controller.selectedSongs),
                    const SizedBox(
                      height: 15,
                    ),

                    // here we will have a search TextField to be able to search the current folder
                    FileSearchTextField(controller: controller),
                    const SizedBox(
                      height: 20,
                    ),

                    // Widget for "Select All" checkbox
                    Obx(() {
                      // Only show if in selection mode
                      if (!controller.isSelectionMode.value) {
                        return const SizedBox.shrink();
                      }

                      // Filter for actual files (audio files) in the current view
                      final audioFilesInView =
                          controller.foundFiles.whereType<File>().toList();

                      // If no audio files are in the current view, don't show the checkbox
                      if (audioFilesInView.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      // Determine if all currently visible audio files are selected
                      final allCurrentlyDisplayedAudioFilesSelected =
                          audioFilesInView.every((file) =>
                              controller.selectedSongs.contains(file.path));

                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0,
                            right: 4.0), // Added right padding for alignment
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Select All",
                                style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(width: 8),
                            Checkbox(
                              value: allCurrentlyDisplayedAudioFilesSelected,
                              onChanged: (bool? shouldSelectAll) {
                                if (shouldSelectAll != null) {
                                  // This method needs to be implemented in FileExplorerController
                                  controller.toggleSelectAllAudioFilesInFolder(
                                      shouldSelectAll);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }),

                    // here by listening to the changes from currentDirectory value notifier we will make a new list of
                    // files and folder from the selected folder and update the UI accordingly
                    Expanded(
                      child: Obx(
                        () {
                          if (controller.isLoading.value) {
                            return const LoadingData();
                          } else if (controller.foundFiles.isEmpty) {
                            return const NoFilesInThisFolder(
                                message: 'No Music Files in This Folder');
                          } else if (controller.errorHappened.value) {
                            return const CanNotLoadData(
                                message: 'Can Not Load Data!');
                          } else {
                            return ListView.builder(
                                shrinkWrap: true,
                                key: const PageStorageKey<String>('file_list'),
                                itemCount: controller.foundFiles.length,
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                itemBuilder: (context, index) {
                                  var currentFile =
                                      controller.foundFiles[index];
                                  return Obx(
                                    () => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: controller.selectedSongs
                                                .contains(currentFile.path)
                                            ? Colors.grey[600]
                                            : Colors.transparent,
                                      ),
                                      child: Card(
                                        child: ListTile(
                                            leading: currentFile is File
                                                ? const Icon(Icons.music_note)
                                                : const Icon(Icons.folder),
                                            title: Text(
                                                FileAndDirectoryUtilities
                                                    .basename(currentFile),
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            onLongPress: () {
                                              if (currentFile is Directory) {
                                                // do nothing
                                              } else {
                                                // long press on audio files will trigger selection mode
                                                // and add the long pressed object in to the selectedSongs list
                                                controller.setIsSelectionMode =
                                                    true;
                                                controller
                                                    .addOrRemoveSelectedSong(
                                                        currentFile.path);
                                              }
                                            },
                                            onTap: () async {
                                              // dismissing the keyboard when taping on search results
                                              FocusScope.of(context).unfocus();
                                              // if selectedSong is empty then set selection mode to false
                                              if (controller
                                                  .selectedSongs.isEmpty) {
                                                controller.setIsSelectionMode =
                                                    false;
                                              }

                                              if (currentFile is Directory) {
                                                // when tap on a directory we will change the current directory
                                                // and load the new current directory's data
                                                controller
                                                    .changeCurrentDirectory(
                                                        Directory(
                                                            currentFile.path));
                                              } else {
                                                // in selection mode we will add(remove) the selected files to selectedSongs
                                                if (controller
                                                    .isSelectionMode.value) {
                                                  controller
                                                      .addOrRemoveSelectedSong(
                                                          currentFile.path);
                                                } else {
                                                  // getting song instance from the selected file
                                                  Song song =
                                                      await FileMetadata()
                                                          .getSong(
                                                              currentFile.path);

                                                  // when tap on audio files we will pass the audio to the SongPlaying Screen
                                                  Get.toNamed(
                                                      AppRoute.songPlayingScreen
                                                          .path,
                                                      arguments: song);
                                                }
                                              }
                                            }),
                                      ),
                                    ),
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            );
          }),
    );
  }
}
