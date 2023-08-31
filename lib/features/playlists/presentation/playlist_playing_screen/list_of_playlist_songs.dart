import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/components/playlist_songs.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_controller.dart';

class ListOfPlaylistSongs extends StatelessWidget {
  const ListOfPlaylistSongs({
    super.key,
    required this.singlePlaylistController,
  });

  final PlaylistPlayingScreenController singlePlaylistController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          itemCount: singlePlaylistController
              .myPlaylist.value.songs.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                await singlePlaylistController.audioPlayer
                    .seek(Duration.zero, index: index);
                singlePlaylistController.currentAudioPlayerIndex
                    .value = singlePlaylistController
                        .audioPlayer.currentIndex ??
                    0;
              },
              child: Obx(
                () => PlaylistSongs(
                    playlist:
                        singlePlaylistController.myPlaylist.value,
                    indexNumber: index + 1,
                    songUrl: singlePlaylistController
                        .myPlaylist.value.songs[index]),
              ),
            );
          });
      // this music player app is developed by master
    });
  }
}


