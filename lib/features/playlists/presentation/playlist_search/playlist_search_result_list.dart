import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/routing/app_routes.dart';
import 'package:mastermediaplayer/common/models/song_model.dart';
import 'package:mastermediaplayer/features/favorites/presentation/song_card2.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_card.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_search/playlist_search_controller.dart';

class PlaylistSearchResultList extends StatelessWidget {
  const PlaylistSearchResultList({
    super.key,
    required this.playlistSearchController,
    required this.playlistsController,
  });

  final PlaylistSearchController playlistSearchController;
  final PlaylistsController playlistsController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: playlistSearchController.foundSongs.length,
        itemBuilder: (context, index) {
          var temp = playlistSearchController.foundSongs[index];

          // the below code will be displayed if the builder is on the last iteration
          if (index == playlistSearchController.foundSongs.length - 1) {
            return Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.toNamed(AppRoute.playlists.path, arguments: {
                      'playlist': playlistsController.myPlaylists[
                          playlistSearchController
                              .foundSongs[index].playlistIndex],
                      'selectedIndex':
                          playlistSearchController.foundSongs[index].songIndex
                    });
                  },
                  child: IgnorePointer(
                    child: SongCard2(
                        song: Song(
                            title: temp.songTitle,
                            artist: temp.artistName,
                            albumTitle: temp.albumTitle,
                            songUrl: '',
                            coverImageUrl: Uint8List(13))),
                  ),
                ),
                // here we are adding the 'foundPlaylists' list at the end of the 'foundSongs' list
                // and since we set the listView setting to NeverScroll it wont be another list
                // it will just use the above list's scrolling function and they will just act like a single list
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: playlistSearchController.foundPlaylist
                      .map((element) => PlaylistCard(myPlaylist: element))
                      .toList(),
                ),
              ],
            );
          }
          // the below code will be executed when the builder starts building lists and is not on the last
          // iteration (normal condition) .. but when it hits it's last index only the above code will be executed.
          return GestureDetector(
            // here setting behavior property of GestureDetector to 'HitTestBehavior.opaque' will allow us
            // to override the child's onTap or onPressed methods with the help of IgnorePointer widget
            // so to do that just wrap the child widget with IgnorePointer and wrap IgnorePointer with a GestureDetector
            // after that we can handle any event we want from the 'onTap' method of the GestureDetector
            // without worrying about any Gesture Handling from the child widget
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Get.toNamed(AppRoute.playlists.path, arguments: {
                'playlist': playlistsController.myPlaylists[
                    playlistSearchController.foundSongs[index].playlistIndex],
                'selectedIndex':
                    playlistSearchController.foundSongs[index].songIndex
              });
            },
            child: IgnorePointer(
              child: SongCard2(
                  song: Song(
                      title: temp.songTitle,
                      artist: temp.artistName,
                      albumTitle: temp.albumTitle,
                      songUrl: '',
                      coverImageUrl: Uint8List(13))),
            ),
          );
        });
  }
}
