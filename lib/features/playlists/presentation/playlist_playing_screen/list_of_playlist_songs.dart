import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/features/playlists/presentation/playlist_song_card/playlist_song_card.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_controller.dart';

class ListOfPlaylistSongs extends StatelessWidget {
  const ListOfPlaylistSongs({
    super.key,
    required this.playlistPlayingScreenController,
  });

  final PlaylistPlayingScreenController playlistPlayingScreenController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          itemCount:
              playlistPlayingScreenController.myPlaylist.value.songs.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                await playlistPlayingScreenController.audioPlayer
                    .seek(Duration.zero, index: index);
                playlistPlayingScreenController.currentAudioPlayerIndex.value =
                    playlistPlayingScreenController.audioPlayer.currentIndex ??
                        0;
              },
              child: Obx(
                () => PlaylistSongCard(
                    playlist: playlistPlayingScreenController.myPlaylist.value,
                    indexNumber: index + 1,
                    songUrl: playlistPlayingScreenController
                        .myPlaylist.value.songs[index]),
              ),
            );
          });
      // this music player app is developed by master
    });
  }
}
