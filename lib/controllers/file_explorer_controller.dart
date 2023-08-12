import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class FileExplorerController extends GetxController {
  FileExplorerController({required this.fileTypes});

  final List<String> fileTypes;
  var currentDir = Directory('').obs;
  var rootDirectory = Directory('').obs;
  // file system entity (FileSystemEntity) represents files and directories
  List<FileSystemEntity> storageList = <FileSystemEntity>[].obs;
  var selectedStorage = Directory('').obs;

  final RxList<FileSystemEntity> _organizedFiles = <FileSystemEntity>[].obs;
  RxList<FileSystemEntity> foundFiles = <FileSystemEntity>[].obs;
  TextEditingController textEditingController = TextEditingController();
  // flag variables - errorHappened is false and isLoading is true by default
  var errorHappened = false.obs;
  var isLoading = true.obs;

  @override
  void onInit() async {
    await initializeFileExplorer();
    super.onInit();
  }

  @override
  void onReady() {
    // here we are setting a get worker [ever], that will call [getDirFiles] every time
    // the current directory [currentDir] changes
    ever(currentDir, (callback) => getDirFiles(filetypes: fileTypes));
    super.onReady();
  }

  @override
  onClose() {
    // disposing controller when deleting the widget
    textEditingController.dispose();
  }

  Future<void> initializeFileExplorer() async {
    // here we will ask permission in case it is not already given while starting the app
    // Utilities().requestPermission();
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Permission.storage.request();
    }
    // getting storage lists
    storageList = await getStorageList();

    // and here we will initialize currentDirectory and rootDirectory with the
    // first storage list (local storage)
    currentDir.value = storageList[0] as Directory;
    rootDirectory.value = storageList[0] as Directory;
    storageList = storageList;

    // initializing the first directory list (root files and folders)
    await getDirFiles(directory: currentDir.value, filetypes: fileTypes);
  }

  Future<List<Directory>> getStorageList() async {
    if (Platform.isAndroid) {
      List<Directory>? storages = await getExternalStorageDirectories();
      if (storages != null) {
        storages = storages.map((Directory e) {
          final List<String> splitedPath = e.path.split("/");
          return Directory(splitedPath
              .sublist(
                  0, splitedPath.indexWhere((element) => element == "Android"))
              .join("/"));
        }).toList();

        return storages;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<List<FileSystemEntity>> getDirFiles(
      {Directory? directory, required List<String> filetypes}) async {
    isLoading.value =
        true; // when we start listing the directory file we will set it to true
    // if directory is passed we will use that, otherwise we will use
    // the currentDir of the controller
    final allFiles = await (directory ?? (currentDir.value))
        .list()
        .doOnError((Object o, StackTrace st) {
      errorHappened.value = true; // since error happened we will set it to true
      isLoading.value = false; // error happened so, we will set it to false
    }).toList();

// and if there is no error or (after the error happened) we will switch back
// the error flag (if we arrive here means no error, so we will set it to false)
    errorHappened.value = false;

    // filter folders and files that has no name and starts with '.'
    final filteredFiles = allFiles.where((element) {
      if (Utilities.basename(element).startsWith('.') ||
          (Utilities.basename(element) == "") ||
          (element is File &&
              !filetypes.contains(Utilities.getFileExtension(element)))) {
        return false;
      } else {
        return true;
      }
    }).toList();

// if there is no any files and folders after filtering, we will return empty list
    if (filteredFiles.isEmpty) {
      foundFiles.value = filteredFiles;

      // if error didn't happen and we are about to return empty list then we will set it to false
      isLoading.value = false;
      return foundFiles;
    } else {
      // making list of only files
      final dirs = filteredFiles.whereType<Directory>().toList();
      // sorting folder list by name.
      dirs.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));

      // making list of only flies.
      List<File> files = filteredFiles.whereType<File>().toList();

      // sorting files list by name.
      files
          .sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));

      // first folders will go to list (if available) then files will go to list.
      _organizedFiles.value = [...dirs, ...files];
      foundFiles.value = List.from(_organizedFiles);
      isLoading.value =
          false; // we finished listing the directory files so, we will set it to false;
      return foundFiles;
    }
  }

  Future<List<FileSystemEntity>> searchFileAndDirectory(
      {required Directory? directory, required String query}) {
    // if the search query is empty return all files in the current directory [_organizedFiles]
    if (query.isEmpty) {
      foundFiles.value = _organizedFiles;
      return Future.value(foundFiles);
    } else {
      // if there is a search query return the search result
      var searchResult = _organizedFiles
          .where((file) => Utilities.basename(file).toLowerCase().contains(
                query.toLowerCase(),
              ))
          .toList();
      foundFiles.value = List.from(searchResult);
      return Future(() => foundFiles);
    }
  }

  Future<bool> onWillPopCallBack() async {
    // Here while pressing back if we didn't reach the root folder we will block the back button handler from
    // popping the page from the stack  by returning "Future false", and return the user to the parent directory.
    // But if we reach the root folder we will allow the handler to pop the page and take us back to the
    // previous page by returning "Future true";

    if (currentDir.value.path != rootDirectory.value.path) {
      changeCurrentDirectory(currentDir.value.parent);
      // changeCurrentDirectory(currentDir.value.parent);
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void changeCurrentDirectory(Directory dir) async {
    // change current directory and clear the search bar if it was not empty
    currentDir.value = dir;
    textEditingController.text = '';
  }
}
