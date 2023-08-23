import 'package:get/get.dart';
import 'package:mastermediaplayer/Constants/constants.dart';

import 'package:mastermediaplayer/features/playlists/data/playlists_repository.dart';
import 'package:mastermediaplayer/features/playlists/domain/playlist_model.dart';
import 'package:mastermediaplayer/models/song_model.dart';
import 'package:mastermediaplayer/services/storage_service.dart';

class LocalPlaylistsRepository extends PlaylistsRepository {
  /// This is a local repository for our playlists list

  final ss = Get.find<StorageService>();
  List<Playlist> myPlaylists = []; // for and to the controller or Ui
  List<dynamic> playlists = []; // for and to the local persistent storage

  @override
  List<Playlist> getPlaylistsList() {
    playlists = ss.read(kplaylistsKey);

    if (playlists.isNotEmpty) {
      for (String jsonPlaylist in playlists) {
        myPlaylists.add(Playlist.fromJson(jsonPlaylist));
      }
    }
    return myPlaylists;
  }

  @override
  List<Playlist> addOrRemovePlaylist(Playlist playlist) {
    if (myPlaylists.contains(playlist)) {
      myPlaylists.remove(playlist);
      playlists.remove(playlist.toJson());
    } else {
      myPlaylists.add(playlist);
      playlists.add(playlist.toJson());
    }
    // writing to the storage
    ss.write(kplaylistsKey, playlist);

    return myPlaylists;
  }

  @override
  List<Playlist> addOrRemoveSongsFromPlaylist(
      Playlist playlist, List<Song> songs) {
    for (var song in songs) {
      if (playlist.songs.contains(song.songUrl)) {
        playlist.songs.remove(song.songUrl);
      } else {
        playlist.songs.add(song.songUrl);
      }
    }
    // here before we set (before updating the existing playlist) we will take it's index and
    // we will put the new (updated playlist) in the old playlist's index
    int index = myPlaylists.indexOf(playlist);
    playlists[index] = playlist.toJson();
    // writing to the storage
    ss.write(kplaylistsKey, playlists);

    return myPlaylists;
  }
}
