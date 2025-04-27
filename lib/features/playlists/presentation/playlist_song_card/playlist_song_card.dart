import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';
import 'package:mastermediaplayer/features/playlists/domain/playlist.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favorites_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_song_card/playlist_song_card_detail.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_song_card/playlist_song_card_popup_menu_button.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_controller.dart';

class PlaylistSongCard extends StatelessWidget {
  PlaylistSongCard({
    Key? key,
    required this.playlist,
    required this.songUrl,
    required this.indexNumber,
  }) : super(key: key);

  final Playlist playlist;
  final String songUrl;
  final int indexNumber;

  final playlistsController = Get.find<PlaylistsController>();

  final playlistPlayingScreenController =
      Get.find<PlaylistPlayingScreenController>();

  final favoritesController = Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NeumorphicContainer(
          padding: 5,
          // margin: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // displaying index number for the list of songs in the playlist
                Text(
                  '$indexNumber',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                // a widget that will display song title, album name and  duration for a given song
                PlaylistSongCardDetail(
                    playlistPlayingScreenController:
                        playlistPlayingScreenController,
                    songUrl: songUrl,
                    indexNumber: indexNumber),
                // popup menu button with 'Remove from playlist' and Add to my favorites options
                PlaylistSongCardPopupMenuButton(
                    playlistPlayingScreenController:
                        playlistPlayingScreenController,
                    favoritesController: favoritesController,
                    indexNumber: indexNumber,
                    playlistsController: playlistsController,
                    playlist: playlist,
                    songUrl: songUrl),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
