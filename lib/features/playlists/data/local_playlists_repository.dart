import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mastermediaplayer/services/storage_service.dart';
import 'package:mastermediaplayer/Constants/local_storage_keys.dart';
import 'package:mastermediaplayer/features/playlists/domain/playlist.dart';
import 'package:mastermediaplayer/features/playlists/data/playlists_repository.dart';

/// this class will be our local repository for our playlists
/// and it will be used to: store the playlists data in the local storage,
/// retrieve the data from the local storage, and add or remove playlists
/// and songs from and to the local storage
class LocalPlaylistsRepository extends PlaylistsRepository {
  /// This is a local repository for our playlists list

  final ss = Get.find<StorageService>();
  List<Playlist> myPlaylists = []; // for and to the controller or Ui
  var playlistsJson = []; // for and to the local persistent storage

  @override
  List<Playlist> getPlaylistsList() {
    playlistsJson = ss.read(playlistsKey);

    if (playlistsJson.isNotEmpty) {
      for (var s in playlistsJson) {
        myPlaylists.add(Playlist.fromJson(s));
      }
      return myPlaylists;
    } else {
      return [];
    }
  }

  @override
  List<Playlist> addOrRemovePlaylist(Playlist playlist) {
    if (myPlaylists.contains(playlist)) {
      myPlaylists.remove(playlist);
      playlistsJson.remove(playlist.toJson());
    } else {
      myPlaylists.add(playlist);
      playlistsJson.add(playlist.toJson());
    }
    // writing to the storage
    ss.write(playlistsKey, playlistsJson);

    return myPlaylists;
  }

  @override
  List<Playlist> addSongsToPlaylist(Playlist playlist, List<String> songUrls) {
    for (var songUrl in songUrls) {
      if (!playlist.songs.contains(songUrl)) {
        playlist.songs.add(songUrl);
      }
    }
    // here before we set (before updating the existing playlist) we will take it's index and
    // we will put the new (updated playlist) in the old playlist's index
    int index = myPlaylists.indexOf(playlist);
    playlistsJson[index] = playlist.toJson();
    // writing to the storage
    ss.write(playlistsKey, playlistsJson);

    return myPlaylists;
  }

  @override
  List<Playlist> removeSongsFromPlaylist(
      Playlist playlist, List<String> songUrls) {
    for (var songUrl in songUrls) {
      if (playlist.songs.contains(songUrl)) {
        playlist.songs.remove(songUrl);
      }
    }
    // here before we set (before updating the existing playlist) we will take it's index and
    // we will put the new (updated playlist) in the old playlist's index
    int index = myPlaylists.indexOf(playlist);
    playlistsJson[index] = playlist.toJson();
    // writing to the storage
    ss.write(playlistsKey, playlistsJson);

    return myPlaylists;
  }

  @override
  Future<List<Playlist>> createPlaylist(
      {required String title,
      required String selectedCoverImage,
      required List<String> selectedSongsUrls}) async {
    Directory applicationDirectory = await getApplicationDocumentsDirectory();
    //this will hold the new image path in the application document directory
    var newImagePath = File('');

    if (selectedCoverImage != '') {
      final File coverImage = File(selectedCoverImage);
      String fileNameWithExtension = coverImage.path.split('/').last;
      newImagePath = await coverImage
          .copy('${applicationDirectory.path}/$fileNameWithExtension');
    }

    // if everything is so good so far we will create a new playlist and save that data permanently
    // by calling addNewPlaylist from playlistController

    Playlist playlist = Playlist(
        title: title,
        songs: selectedSongsUrls,
        coverImageUrl: selectedCoverImage == ''
            ? 'assets/images/playlist.png'
            : newImagePath.path);

// updating playlists list and store it to the local storage
    addOrRemovePlaylist(playlist);

    return myPlaylists;
  }

// clear playlist repository
  List<Playlist> clearPlaylists() {
    myPlaylists.clear();
    return myPlaylists;
  }
}
