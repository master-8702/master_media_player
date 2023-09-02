import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/common/widgets/music_seekbar_slider.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favoritesController.dart';
import 'package:mastermediaplayer/features/player/presentation/song_player_body.dart';
import 'package:mastermediaplayer/features/player/presentation/song_player_header.dart';
import 'package:mastermediaplayer/features/player/presentation/song_playing_screen_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_control_buttons.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';

import '../../../common/widgets/Player_buttons.dart';

// this class is going to build the UI for a SOngPlayingScreen that is going to open when we select
// a single music using the music explorer option
class SongPlayingScreen extends StatelessWidget {
  SongPlayingScreen({Key? key}) : super(key: key);

  final SongPlayingScreenController controller =
      Get.put(SongPlayingScreenController());

  final playlistsController = Get.find<PlaylistsController>();
  final favoritesController = Get.find<FavoritesController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // to avoid bottom Overflowed error while the keyboard pops up
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                // back button, Now playing text, option button for add to playlist, sleep timer and music info
                child: SongPlayerHeader(
                    playlistsController: playlistsController,
                    song: controller.songList.first,
                    controller: controller),
              ),
              const SizedBox(
                height: 15,
              ),

              // cover art, song name , artist name
              SongPlayerBody(
                  song: controller.songList.first,
                  songPlayingScreenController: controller,
                  favoritesController: favoritesController),
              const SizedBox(
                height: 10,
              ),

              // start time , (if playlist) shuffle button, (if playlist) repeat button, end time
              PlaylistControlButtons(audioPlayer: controller.audioPlayer.value),
              const SizedBox(
                height: 15,
              ),
              // music duration slider
              MusicSeekbarSlider(
                audioPlayer: controller.audioPlayer.value,
                seekBarDataStream: controller.musicSliderDragPositionDataStream,
              ),

              const SizedBox(
                height: 15,
              ),
              // previous song , ply/pause, next song buttons
              // this music player app is developed by master

              PlayerButtons(
                audioPlayer: controller.audioPlayer.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
