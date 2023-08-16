import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/components/music_seekbar_slider.dart';
import 'package:mastermediaplayer/controllers/playlistsController.dart';
import 'package:mastermediaplayer/features/player/presentation/song_player_body.dart';
import 'package:mastermediaplayer/features/player/presentation/song_player_header.dart';
import 'package:mastermediaplayer/features/player/presentation/song_playing_screen_controller.dart';

import '../../../components/PlayerButtons.dart';
import '../../../components/PlaylistControlButtons.dart';

// this class is going to build the UI for a SOngPlayingScreen that is going to open when we select
// a single music using the music explorer option
class SongPlayingScreen extends StatelessWidget {
  SongPlayingScreen({Key? key}) : super(key: key);

  late final SongPlayingScreenController controller =
      Get.put(SongPlayingScreenController());

  final PlaylistsController playlistsController =
      Get.put(PlaylistsController());

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
                child: SongPlayerHeader(
                    playlistsController: playlistsController,
                    song: controller.songList.first,
                    controller: controller),
              ),
              const SizedBox(
                height: 15,
              ),

              // cover art, song name , artist name, album name
              SongPlayerBody(
                  song: controller.songList.first, controller: controller),
              const SizedBox(
                height: 10,
              ),

              // start time , shuffle button, repeat button, end time
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

              PlayerButtons(audioPlayer: controller.audioPlayer.value),

              // playing time indicator (progress bar)
            ],
          ),
        ),
      ),
    );
  }
}
