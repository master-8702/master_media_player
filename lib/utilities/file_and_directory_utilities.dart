import 'dart:io';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

/// File and Directory related utilities
class FileAndDirectoryUtilities {
  static List<Directory> storageList = [];
  static late List<FileSystemEntity> folderList;
  
  
/// To request storage access permission
void requestPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Permission.storage.request();
    }
  }

/// To get directory lists
   static List<FileSystemEntity> getDirectories(
      [String path = '/storage/emulated/0']) {
    Directory rootDir = storageList.first;
    Directory dir = Directory(rootDir.path);
    List<FileSystemEntity> allFilesAndFolders =
        dir.listSync(recursive: true, followLinks: false);

    // myFolders = List<FileSystemEntity>.from(allFilesAndFolders);
    return allFilesAndFolders;
  }

  /// To bet the root directory
  static Directory getRootDirectory(FileSystemEntity entity) {
    final Directory parent = entity.parent;
    if (parent.path == entity.path) return parent;
    return getRootDirectory(parent);
  }

/// To check if a given FileSystemEntity instance is a file
  static bool isFile(FileSystemEntity entity) {
    return (entity is File);
  }

/// To check if a given FileSystemEntity instance is a directory
  static bool isDirectory(FileSystemEntity entity) {
    return (entity is Directory);
  }

/// To get a given FileSystemEntity instance's basename (file name)
  static String basename(dynamic entity, [bool showFileExtension = true]) {
    if (entity is Directory) {
      return entity.path.split('/').last;
    } else if (entity is File) {
      return (showFileExtension)
          ? entity.path.split('/').last.split('.').first
          : entity.path.split('/').last;
    } else {
      debugPrint(
          "Please provide a Object of type File, Directory or FileSystemEntity");
      return "";
    }
  }

/// To get the file extension of a given file  
  static String getFileExtension(FileSystemEntity file) {
    if (file is File) {
      return file.path.split("/").last.split('.').last;
    } else {
      throw "FileSystemEntity is Directory, not a File";
    }
  }

  }