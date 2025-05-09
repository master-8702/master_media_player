import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';
import 'package:mastermediaplayer/utilities/file_and_directory_utilities.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_controller.dart';

// this widget will show the current song title in a scrollable text
// inside a playlist playing screen
class CurrentSongScrollableTitle extends StatelessWidget {
  const CurrentSongScrollableTitle({
    super.key,
    required this.playlistPlayingScreenController,
  });

  final PlaylistPlayingScreenController playlistPlayingScreenController;

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
              FileAndDirectoryUtilities.basename(
                File(playlistPlayingScreenController.myPlaylist.value.songs[
                    playlistPlayingScreenController
                        .currentAudioPlayerIndex.value]),
              ),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              velocity: const Velocity(pixelsPerSecond: Offset(30, 30)),
            ),
          ],
        ),
      ),
    );
  }
}
