import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_controller.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';

class CurrentSongScrollableTitle extends StatelessWidget {
  const CurrentSongScrollableTitle({
    super.key,
    required this.singlePlaylistController,
  });

  final PlaylistPlayingScreenController singlePlaylistController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NeumorphicContainer(
        padding: 10,
        child: Column(
          children: [
            const Text('Now Playing:'),
            const SizedBox(
              height: 10,
            ),
            TextScroll(
              Utilities.basename(
                File(
                    singlePlaylistController.myPlaylist.value.songs[
                        singlePlaylistController
                            .currentAudioPlayerIndex.value]),
              ),
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
              velocity:
                  const Velocity(pixelsPerSecond: Offset(30, 30)),
            ),
          ],
        ),
      ),
    );
  }
}
