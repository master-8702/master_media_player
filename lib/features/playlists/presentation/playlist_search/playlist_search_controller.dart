import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';

import 'package:mastermediaplayer/features/playlists/domain/playlist.dart';
import 'package:mastermediaplayer/utilities/file_and_directory_utilities.dart';
import 'package:mastermediaplayer/features/playlists/domain/searchable_playlist.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';

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
        AudioMetadata? metaData;
        try {
          metaData =
              readMetadata(File(myPlaylist2[i].songs[j]), getImage: true);
        } catch (e) {
          if (!kReleaseMode) {
            debugPrint('Error reading metadata: $e');
          }
        }

        SearchablePlaylist searchablePlaylist = SearchablePlaylist(
            albumTitle: metaData?.album ?? 'Unknown Album',
            artistName: metaData?.artist != null
                ? metaData!.artist.toString()
                : 'Unknown Artist',
            playlistIndex: i,
            songIndex: j,
            songTitle: FileAndDirectoryUtilities.basename(
                File(myPlaylist2[i].songs[j])));

        searchablePlaylists.add(searchablePlaylist);
      }
    }
    // here we will put search results from songTitle, artistNames, albumName
    // and playlistTitle then we will concatenate them in a single list
    // (all related to musics) and another list for playlist related results
    // based on their importance probability in the following order: first
    // result from songTitle then artistName then albumName then Playlist title

    // here we are converting the searchQuery to lower case to make the search
    // case insensitive
    final searchQueryLowerCase = searchQuery.toLowerCase();

    // here we are searching the query in the song title, artist name and
    // album title in one go
    final foundFromMediaItems = searchablePlaylists.where((item) {
      final songMatch =
          item.songTitle.toLowerCase().contains(searchQueryLowerCase);
      final artistMatch =
          item.artistName.toLowerCase().contains(searchQueryLowerCase);
      final albumMatch =
          item.albumTitle.toLowerCase().contains(searchQueryLowerCase);
      return songMatch || artistMatch || albumMatch;
    }).toList();

    // here we are searching the query in the playlist titles
    var foundResultFromPlaylistTitles = playlistsController.myPlaylists
        .where((element) =>
            element.title.toLowerCase().contains(searchQueryLowerCase))
        .toList();

    foundSongs.value = [
      ...foundFromMediaItems,
    ];
    foundPlaylist.value = [...foundResultFromPlaylistTitles];
  }
}
