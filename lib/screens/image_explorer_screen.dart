import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/Constants/constants.dart';
import 'package:mastermediaplayer/common/file_explorer/can_not_load_data.dart';
import 'package:mastermediaplayer/common/file_explorer/file_explorer_header.dart.dart';
import 'package:mastermediaplayer/common/file_explorer/file_search_text_field.dart';
import 'package:mastermediaplayer/common/file_explorer/loading_data.dart';
import 'package:mastermediaplayer/common/file_explorer/no_files_in_this_folder.dart';
import 'package:mastermediaplayer/controllers/file_explorer_controller.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';

// this class is going to help us in basic file(Picture) exploring from the available storage devices in the phone
// and it will be used to select singe image file from the storage in order to assign it as a cover image for our playlists.
// it will also allow us to preview the images without opening them (as a prefix icon in the listTie)
class ImageExplorerScreen extends StatelessWidget {
  ImageExplorerScreen({Key? key}) : super(key: key);

  final FileExplorerController controller =
      Get.put(FileExplorerController(fileTypes: kSupportedImageFormats));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: controller.onWillPopCallBack,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                FileExplorerHeader(controller: controller),
                const SizedBox(
                  height: 15,
                ),
                FileSearchTextField(controller: controller),
                const SizedBox(
                  height: 20,
                ),

                // here by listening to the changes from currentDirectory value notifier we will make a new list of
                // files and folder from the selected folder and update the UI accordingly
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const LoadingData();
                    } else if (controller.foundFiles.isEmpty) {
                      return const NoFilesInThisFolder(
                          message: 'No Image Files in This Folder');
                    } else if (controller.errorHappened.value) {
                      return const CanNotLoadData(
                          message: 'Can Not Load Data!');
                    } else {
                      return ListView.builder(
                          itemCount: controller.foundFiles.length,
                          itemBuilder: (context, index) {
                            var currentFile = controller.foundFiles[index];
                            return Card(
                              child: ListTile(
                                  leading: currentFile is File
                                      ? Container(
                                          width: 75,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: FileImage(currentFile),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          // this one [Image.file] is a little bit faster than a [FileImage] when scrolling inside  a page 
                                          // that has too many images. we might return to this implementation.
                                          // child: Image.file(
                                          //   cacheHeight: 100,
                                          //   cacheWidth: 100,
                                          //   currentFile,
                                          //   fit: BoxFit.cover,
                                          // ),
                                        )
                                      : const Icon(Icons.folder),
                                  title: Text(Utilities.basename(currentFile),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  onTap: () async {
                                    if (currentFile is Directory) {
                                      controller.currentDir.value = currentFile;
                                    } else {
                                      // return the selected image back to the previous page
                                      Get.back(result: currentFile.path);
                                    }
                                  }),
                            );
                          });
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
