import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/features/playlists/domain/playlist.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/features/playlists/domain/searchable_playlist.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';

class PlaylistSearchController extends GetxController {
  final playlistsController = Get.find<PlaylistsController>();

  // in the following two variables we will put the search results from musics and playlists respectively
  var foundSongs = <SearchablePlaylist>[].obs;
  var foundPlaylist = <Playlist>[].obs;

  void playlistSearcher(String searchQuery) async {
    var myPlaylist2 = playlistsController.myPlaylists;
    // here first we will convert all playlists to SearchablePlaylist
    List<SearchablePlaylist> searchablePlaylists = [];
    for (int i = 0; i < myPlaylist2.length; i++) {
      for (int j = 0; j < myPlaylist2[i].songs.length; j++) {
        Metadata metaData =
            await MetadataRetriever.fromFile(File(myPlaylist2[i].songs[j]));
        SearchablePlaylist searchablePlaylist = SearchablePlaylist(
            albumTitle: metaData.albumName ?? 'Unknown Album',
            artistName: metaData.trackArtistNames != null
                ? metaData.trackArtistNames!.toList().toString()
                : 'Unknown Artist',
            playlistIndex: i,
            songIndex: j,
            songTitle: Utilities.basename(File(myPlaylist2[i].songs[j])));
        searchablePlaylists.add(searchablePlaylist);
      }
    }
    // here we will put search results from each search types like from songTitle, artisNames, playlistTitle separately...
    // then we will concatenate them in a single list (all related to musics) and another list for playlist related results
    // based on their importance probability in the following order: first result from songTitle then artistName then albumName then Playlist title
    var foundResultFromSongTitles = searchablePlaylists
        .where((element) =>
            element.songTitle.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    var foundResultFromArtistNames = searchablePlaylists
        .where((element) => element.artistName.contains(searchQuery))
        .toList();

    var foundResultFromAlbumTitles = searchablePlaylists
        .where((element) => element.albumTitle.contains(searchQuery))
        .toList();
    var foundResultFromPlaylistTitles = playlistsController.myPlaylists
        .where((element) => element.title.contains(searchQuery))
        .toList();

    foundSongs.value = [
      ...foundResultFromSongTitles,
      ...foundResultFromArtistNames,
      ...foundResultFromAlbumTitles,
    ];
    foundPlaylist.value = [...foundResultFromPlaylistTitles];
  }
}
