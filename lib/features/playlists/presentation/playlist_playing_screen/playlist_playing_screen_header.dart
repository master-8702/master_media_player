import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/controllers/timerController.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_popup_menu.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';

class PlaylistPlayingScreenHeader extends StatelessWidget {
  const PlaylistPlayingScreenHeader({
    super.key,
    required this.singlePlaylistController,
    required this.playlistsController,
    required this.timerTextEditingController,
    required this.timerController,
  });

  final PlaylistPlayingScreenController singlePlaylistController;
  final PlaylistsController playlistsController;
  final TextEditingController timerTextEditingController;
  final TimerController timerController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // menu and back button
        SizedBox(
          height: 60,
          width: 60,
          child: NeumorphicContainer(
            child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_rounded,
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.55,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                maxLines: 2,
                textAlign: TextAlign.center,
                singlePlaylistController.myPlaylist.value.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontSize: 18),
              ),
            ),
          ),
        ),
        // playlist playing screen pop up menu, to add music to the playlist
        // or set sleep timer
        PlaylistPopUpMenu(playlistsController: playlistsController, singlePlaylistController: singlePlaylistController, timerTextEditingController: timerTextEditingController, timerController: timerController),
      ],
    );
  }
}

