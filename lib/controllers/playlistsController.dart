import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mastermediaplayer/models/playlist_model.dart';

import '../components/utilities/utilities.dart';
import '../models/song_model.dart';

// this class is going to be used as state manager (controller) for playlists
// it will be used mainly on homepage and myPlaylistsPage

class PlaylistsController extends GetxController {
  // the 'myPlaylists' is list of playlists ready to be displayed on home page and playlist page

  List<Playlist> myPlaylists = [];
  List<dynamic> playlists = [];
  List<dynamic> selectedSongs = [].obs;
  var currentAudioPlayerIndex = 0.obs;
  GetStorage box = GetStorage();

  // this method will initializes the playlists by reading from local storage
  void getPlaylists() async {
    if (box.read('myPlaylist') == null) {
      box.write('myPlaylist', <String>[]);
    }

    playlists = box.read('myPlaylist');

    if (playlists.isNotEmpty) {
      for (String playlistAsString in playlists) {
        myPlaylists.add(Playlist.fromString(playlistAsString));
      }
    }

    update();
  }

  void addNewPlaylist(Playlist playlist) {
    myPlaylists.add(playlist);
    playlists.add(playlist.toString());
    box.write('myPlaylist', playlists);

    update();
  }

// this method is used for removing favorite music from the already existing list
// and update the UI accordingly using the 'update' method of GetX state management (update will force the rebuilding of the UI)
  void removePlaylist(Playlist playlist) {
    myPlaylists.remove(playlist);
    playlists.remove(playlist.toString());
    box.write('myPlaylist', playlists);
    update();
  }

  void addMusicToPlaylist(Playlist playlist, List<String> songUrl) {
    if (songUrl.isNotEmpty) {
      List<String> songUrls = playlist.songs;
      for (String musicPath in songUrl) {
        songUrls.addIf(!songUrls.contains(musicPath), musicPath);
      }
      // here before we set (before updating the existing playlist) we will take it's index and
      // we will put the new (updated playlist) in the old playlist's index
      int index = myPlaylists.indexOf(playlist);
      playlist.setSong = songUrls;
      // myPlaylists[index] = playlist;
      playlists[index] = playlist.toString();
      box.write('myPlaylist', playlists);
    }

    //and update the UI to reflect the new changes
    update();
  }

  void removeSongFromPlaylist(Playlist playlist, Song song) {
    List<String> songUrls = playlist.songs;
    songUrls.remove(song.songUrl);

    int index = myPlaylists.indexOf(playlist);
    playlist.setSong = songUrls;
    // myPlaylists[index] = playlist;
    playlists[index] = playlist.toString();
    box.write('myPlaylist', playlists);
    update();
  }

  void justRebuildTheUi(int index) {
    currentAudioPlayerIndex.value = index;
    update();
  }
}
