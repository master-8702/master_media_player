import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/Constants/constants.dart';
import 'package:mastermediaplayer/common/file_explorer/can_not_load_data.dart';
import 'package:mastermediaplayer/common/file_explorer/file_search_text_field.dart';
import 'package:mastermediaplayer/common/file_explorer/loading_data.dart';
import 'package:mastermediaplayer/common/file_explorer/no_files_in_this_folder.dart';
import 'package:mastermediaplayer/common/file_explorer/song_explorer_header.dart';
import 'package:mastermediaplayer/controllers/file_explorer_controller.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';



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
  FileExplorerController controller =
      Get.put(FileExplorerController(fileTypes: kSupportedAudioFormats));
  var selectedSongs = <String>[].obs;
 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: controller.onWillPopCallBack,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              SongExplorerHeader(controller: controller, selectedSongs: selectedSongs),
              const SizedBox(
                height: 15,
              ),

              // here we will have a search TextField to be able to search the current folder
              FileSearchTextField(controller: controller),
              const SizedBox(
                height: 20,
              ),

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
                        itemCount: controller.foundFiles.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onLongPress: () {
                              selectedSongs
                                  .add(controller.foundFiles[index].path);
                            },
                            child: Card(
                              child: Obx(
                                () {
                                  return CheckboxListTile(
                                    value: selectedSongs.contains(
                                        controller.foundFiles[index].path),
                                    title: Text(
                                        Utilities.basename(
                                            controller.foundFiles[index]),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    onChanged: (value) async {
                                      if (controller.foundFiles[index]
                                          is Directory) {
                                        controller.currentDir.value = controller
                                            .foundFiles[index] as Directory;
                                      } else {
                                        if (selectedSongs.contains(controller
                                            .foundFiles[index].path)) {
                                          selectedSongs.remove(controller
                                              .foundFiles[index].path);
                                        } else {
                                          selectedSongs.add(controller
                                              .foundFiles[index].path);
                                        }
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

