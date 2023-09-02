import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:mastermediaplayer/common/models/song_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Utilities {
  static List<Directory> storageList = [];
  static late List<FileSystemEntity> folderList;

  void requestPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Permission.storage.request();
    }
  }

  static void setUp() async {
    storageList = await getStorageList();
    // folderList = getDirectories(storageList[0].path);
  }

  static Future<Metadata> getMetadata(String fileName) async {
    Metadata metadata = await MetadataRetriever.fromFile(File(fileName));
    return metadata;
  }

  Future<Song> getSong(String songPath) async {
    Metadata metadata = await MetadataRetriever.fromFile(File(songPath));

    Song song = Song(
        title: Utilities.basename(File(songPath)),
        artist: metadata.trackArtistNames != null
            ? metadata.trackArtistNames!.toList().toString()
            : 'Unknown Artist',
        albumTitle: metadata.albumName != null
            ? metadata.albumName.toString()
            : 'Unknown Album',
        songUrl: songPath,
        coverImageUrl: metadata.albumArt != null
            ? metadata.albumArt as Uint8List
            : Uint8List(13));

    return song;
  }

  static List<FileSystemEntity> getDirectories(
      [String path = '/storage/emulated/0']) {
    Directory rootDir = storageList.first;
    Directory dir = Directory(rootDir.path);
    List<FileSystemEntity> allFilesAndFolders =
        dir.listSync(recursive: true, followLinks: false);

    // myFolders = List<FileSystemEntity>.from(allFilesAndFolders);
    return allFilesAndFolders;
  }

  static String formatDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    } else {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }
  }

  static Directory getRootDirectory(FileSystemEntity entity) {
    final Directory parent = entity.parent;
    if (parent.path == entity.path) return parent;
    return getRootDirectory(parent);
  }

  static bool isFile(FileSystemEntity entity) {
    return (entity is File);
  }

// check weather FileSystemEntity is Directory
  /// return true if FileSystemEntity is a Directory else returns Directory
  static bool isDirectory(FileSystemEntity entity) {
    return (entity is Directory);
  }

  static String basename(dynamic entity, [bool showFileExtension = true]) {
    if (entity is Directory) {
      return entity.path.split('/').last;
    } else if (entity is File) {
      return (showFileExtension)
          ? entity.path.split('/').last.split('.').first
          : entity.path.split('/').last;
    } else {
      print(
          "Please provide a Object of type File, Directory or FileSystemEntity");
      return "";
    }
  }

  static String getFileExtension(FileSystemEntity file) {
    if (file is File) {
      return file.path.split("/").last.split('.').last;
    } else {
      throw "FileSystemEntity is Directory, not a File";
    }
  }

  static Future<List<Directory>> getStorageList() async {
    if (Platform.isAndroid) {
      List<Directory> storages = (await getExternalStorageDirectories())!;
      storages = storages.map((Directory e) {
        final List<String> splitedPath = e.path.split("/");
        return Directory(splitedPath
            .sublist(
                0, splitedPath.indexWhere((element) => element == "Android"))
            .join("/"));
      }).toList();

      return storages;
    }
    return [];
  }
}

// import 'package:path_provider/path_provider.dart';
//
// final Directory root = findRoot(await getApplicationDocumentsDirectory());
