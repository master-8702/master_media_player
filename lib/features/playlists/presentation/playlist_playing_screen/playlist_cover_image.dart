import 'dart:io';
import 'package:flutter/material.dart';

import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/controllers/timerController.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/timer_display.dart';

class PlaylistCoverImage extends StatelessWidget {
  const PlaylistCoverImage({
    super.key,
    required this.singlePlaylistController,
    required this.timerController,
  });

  final PlaylistPlayingScreenController singlePlaylistController;
  final TimerController timerController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.33,
      width: MediaQuery.of(context).size.width,
      child: Stack(alignment: Alignment.topCenter, children: [
        NeumorphicContainer(
          padding: 10,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: singlePlaylistController
                            .myPlaylist.value.coverImageUrl ==
                        'assets/images/playlist.png'
                    ? Image.asset(
                        singlePlaylistController
                            .myPlaylist.value.coverImageUrl,
                        height: MediaQuery.of(context).size.height *
                            0.3,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(singlePlaylistController
                            .myPlaylist.value.coverImageUrl),
                        height: MediaQuery.of(context).size.height *
                            0.3,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
              ),
            ],
          ),
        ),
        // sleep timer display
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: TimerDisplay(timerController: timerController),
        ),
      ]),
    );
  }
}
