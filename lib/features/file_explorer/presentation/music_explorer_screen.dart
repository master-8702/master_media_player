import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/Constants/constants.dart';
import 'package:mastermediaplayer/features/file_explorer/common/can_not_load_data.dart';
import 'package:mastermediaplayer/features/file_explorer/common/file_explorer_header.dart.dart';
import 'package:mastermediaplayer/features/file_explorer/common/file_search_text_field.dart';
import 'package:mastermediaplayer/features/file_explorer/common/loading_data.dart';
import 'package:mastermediaplayer/features/file_explorer/common/no_files_in_this_folder.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/file_explorer_controller.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';
import 'package:mastermediaplayer/common/models/song_model.dart';

class MusicExplorerScreen extends StatefulWidget {
  /// This class is going to help us in basic file(music) exploring from the available storage devices in the phone
  /// and it will only be used to open (play) a certain music file from the storage.
  const MusicExplorerScreen({Key? key}) : super(key: key);

  @override
  State<MusicExplorerScreen> createState() => _MusicExplorerScreenState();
}

class _MusicExplorerScreenState extends State<MusicExplorerScreen> {
  FileExplorerController controller =
      Get.put(FileExplorerController(fileTypes: kSupportedAudioFormats));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // overriding the back button using [WillPopScope]
      child: WillPopScope(
        onWillPop: controller.onWillPopCallBack,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              FileExplorerHeader(controller: controller),
              const SizedBox(
                height: 15,
              ),
              // here we will have a search TextField to be able to search the current folder
              FileSearchTextField(controller: controller),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const LoadingData();
                  } else if (controller.foundFiles.isEmpty) {
                    return const NoFilesInThisFolder(
                        message: 'No Music Files in This Folder');
                  } else if (controller.errorHappened.value) {
                    return const CanNotLoadData(message: 'Can Not Load Data!');
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        key: const PageStorageKey<String>('file_list'),
                        itemCount: controller.foundFiles.length,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                                leading: controller.foundFiles[index] is File
                                    ? const Icon(Icons.music_note)
                                    : const Icon(Icons.folder),
                                title: Text(
                                    Utilities.basename(
                                        controller.foundFiles[index]),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                onTap: () async {
                                  // dismissing the keyboard when taping on search results
                                  FocusScope.of(context).unfocus();

                                  if (controller.foundFiles[index]
                                      is Directory) {
                                    // when tap on a directory we will change the current directory
                                    // and load the new current directory's data
                                    controller.changeCurrentDirectory(Directory(
                                        controller.foundFiles[index].path));
                                  } else {
                                    // when tap on audio files we will pass the audio to the SongPlaying Screen
                                    Song song = await Utilities().getSong(
                                        controller.foundFiles[index].path);

                                    Get.toNamed('songPlaying', arguments: song);
                                  }
                                }),
                          );
                        });
                  }
                }),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
