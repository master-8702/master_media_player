import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';

import 'package:mastermediaplayer/common/models/song_model.dart';
import 'package:mastermediaplayer/utilities/file_and_directory_utilities.dart';

class FileMetadata {
  static List<Directory> storageList = [];
  static late List<FileSystemEntity> folderList;


/// To get the metadata of a given file 
  static Future<Metadata> getMetadata(String fileName) async {
    Metadata metadata = await MetadataRetriever.fromFile(File(fileName));
    return metadata;
  }


/// To create and get a new Song instance including the metadata
  Future<Song> getSong(String songPath) async {
    Metadata metadata = await MetadataRetriever.fromFile(File(songPath));

    Song song = Song(
        title: FileAndDirectoryUtilities.basename(File(songPath)),
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
}
