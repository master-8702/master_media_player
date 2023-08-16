import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/controllers/playlistsController.dart';
import 'package:mastermediaplayer/features/player/presentation/add_to_playlist.dart';
import 'package:mastermediaplayer/features/player/presentation/get_music_info.dart';
import 'package:mastermediaplayer/features/player/presentation/set_sleep_timer.dart';
import 'package:mastermediaplayer/features/player/presentation/song_playing_screen_controller.dart';
import 'package:mastermediaplayer/models/song_model.dart';

class SongPlayerHeader extends StatelessWidget {
  const SongPlayerHeader({
    super.key,
    required this.playlistsController,
    required this.song,
    required this.controller,
  });

  final PlaylistsController playlistsController;
  final Song song;
  final SongPlayingScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        Text("Now Playing", style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(
          width: 60,
          height: 60,
          child: NeumorphicContainer(
            child: PopupMenuButton(
              icon: const Icon(
                Icons.menu_rounded,
              ),
              position: PopupMenuPosition.under,
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 'Add To Playlist',
                    child: ListTile(
                      leading: Icon(Icons.add_circle),
                      title: Text('Add To Playlist'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Sleep Timer',
                    child: ListTile(
                      leading: Icon(Icons.timer_rounded),
                      title: Text('Sleep Timer'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Music Info',
                    child: ListTile(
                      leading: Icon(Icons.info_rounded),
                      title: Text('Music Info'),
                    ),
                  )
                ];
              },
              onSelected: (selectedValue) {
                // this future .delayed is added in order to fix the
                // showDialog and AlertDialog not handling onTap event properly

                Future.delayed(const Duration(seconds: 0), () {
                  if (selectedValue == 'Add To Playlist') {
                    addToPlaylist(context, playlistsController, song);
                  } else if (selectedValue == 'Sleep Timer') {
                    return setSleepTimer(context, controller);
                  } else if (selectedValue == 'Music Info') {
                    getMusicInfo(context, song);
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
