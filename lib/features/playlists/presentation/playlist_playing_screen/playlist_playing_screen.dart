import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/common/widgets/player_buttons.dart';
import 'package:mastermediaplayer/common/controllers/timer_controller.dart';
import 'package:mastermediaplayer/common/widgets/music_seekbar_slider.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_control_buttons.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_cover_image.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/list_of_playlist_songs.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/current_song_scrollable_title.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_header.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_controller.dart';

// this class is going to be used for displaying a single playlist page UI with a list of songs from that playlist
class PlaylistPlayingScreen extends StatefulWidget {
  const PlaylistPlayingScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistPlayingScreen> createState() => _PlaylistPlayingScreenState();
}

class _PlaylistPlayingScreenState extends State<PlaylistPlayingScreen> {
  final PlaylistPlayingScreenController playlistPlayingScreenController =
      Get.put(PlaylistPlayingScreenController());
  final playlistsController = Get.find<PlaylistsController>();

  final TextEditingController timerTextEditingController =
      TextEditingController();
  TimerController timerController = TimerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Column(
              children: [
                // playlist header, back button - playlist title - popup menu
                PlaylistPlayingScreenHeader(
                  playlistPlayingScreenController:
                      playlistPlayingScreenController,
                  playlistsController: playlistsController,
                  timerTextEditingController: timerTextEditingController,
                  timerController: timerController,
                ),
                const SizedBox(
                  height: 25,
                ),
                // playlist cover image and sleep timer display (with stack widget)
                PlaylistCoverImage(
                    playlistPlayingScreenController:
                        playlistPlayingScreenController,
                    timerController: timerController),
                const SizedBox(
                  height: 15,
                ),
                // selected playlist title (scrollable text)
                CurrentSongScrollableTitle(
                    playlistPlayingScreenController:
                        playlistPlayingScreenController),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // shuffle and loop buttons
                    PlaylistControlButtons(
                        audioPlayer:
                            playlistPlayingScreenController.audioPlayer),
                    const SizedBox(
                      height: 15,
                    ),
                    // song duration and position display (slider)
                    MusicSeekBarSlider(
                      audioPlayer: playlistPlayingScreenController.audioPlayer,
                      seekBarDataStream: playlistPlayingScreenController
                          .musicSliderDragPositionDataStream,
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    // previous , ply/pause, next buttons
                    PlayerButtons(
                      audioPlayer: playlistPlayingScreenController.audioPlayer,
                      playlistPlayingScreenController:
                          playlistPlayingScreenController,
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(
                  height: 15,
                ),
                // list of songs from the the selected playlist
                ListOfPlaylistSongs(
                    playlistPlayingScreenController:
                        playlistPlayingScreenController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
