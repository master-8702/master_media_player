import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import 'package:mastermediaplayer/common/controllers/timerController.dart';
import 'package:mastermediaplayer/features/player/domain/music_slider_position_data.dart';
import 'package:mastermediaplayer/common/models/song_model.dart';

class SongPlayingScreenController extends GetxController {

  // here [Get.arguments] is used for getting data passed from the previous page
  // eg. from home page when we click one favorite music to the song playing screen and
  // this controller [SongPlayingScreenController] is inside song playing screen. 
  final Song song = Get.arguments;

  late final List<Song> songList;
  late Rx<AudioPlayer> audioPlayer = AudioPlayer().obs;
  var timerController = TimerController().obs;
  final TextEditingController timerTextEditingController =
      TextEditingController();

  @override
  void onInit() {
    songList = [song];
    try {
      // audioPlayer.setFilePath(song.songUrl);
      audioPlayer.value
          .setAudioSource(AudioSource.uri(Uri.file(songList.first.songUrl)));
    } catch (e) {
      print("Error loading audio source: $e");
    }
    super.onInit();
  }

  @override
  void onClose() {
    audioPlayer.value.dispose();
    super.onClose();
  }

  // here are gonna use two different Duration streams position stream and duration stream from
  // the audioPlayer instance and we will combine them using the rxdart library
  // to pass them as a single stream for slider widget of our player 
  Stream<MusicSliderPositionData> get musicSliderDragPositionDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, MusicSliderPositionData>(
        audioPlayer.value.positionStream,
        audioPlayer.value.durationStream,
        (Duration position, Duration? duration) =>
            MusicSliderPositionData(position, duration ?? Duration.zero),
      );
}
