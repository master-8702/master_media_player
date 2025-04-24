import 'dart:io';
import 'dart:typed_data';

import 'package:mastermediaplayer/common/models/song_model.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:mastermediaplayer/utilities/file_and_directory_utilities.dart';

// a utility class for metadata related operations
class FileMetadata {
  static List<Directory> storageList = [];
  static late List<FileSystemEntity> folderList;

  /// To get the metadata of a given file
  static Future getMetadata(String fileName) async {
    AudioMetadata metadata = readMetadata(File(fileName), getImage: true);
    return metadata;
  }

  /// To create and get a new Song instance including the metadata
  Future<Song> getSong(String songPath) async {
    try {
      AudioMetadata metadata = readMetadata(File(songPath), getImage: true);

      Song song = Song(
          title: FileAndDirectoryUtilities.basename(File(songPath)),
          artist: metadata.artist != null
              ? metadata.artist.toString()
              : 'Unknown Artist',
          albumTitle: metadata.album != null
              ? metadata.album.toString()
              : 'Unknown Album',
          songUrl: songPath,
          coverImageUrl: metadata.pictures.isNotEmpty
              ? metadata.pictures[0].bytes
              : Uint8List(13));

      return song;
    } catch (e) {
      // print('Error getting song metadata: $e');
      return Song(
          songUrl: songPath,
          title: FileAndDirectoryUtilities.basename(File(songPath)),
          coverImageUrl: Uint8List(13));
    }
  }
}
