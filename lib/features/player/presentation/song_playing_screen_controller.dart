import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mastermediaplayer/controllers/timerController.dart';
import 'package:mastermediaplayer/features/player/domain/music_slider_position_data.dart';
import 'package:mastermediaplayer/models/song_model.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

// import 'package:mastermediaplayer/features/player/domain/song_model.dart';

class SongPlayingScreenController extends GetxController {
  SongPlayingScreenController({required this.songList});

  final List<Song> songList;
  late Rx<AudioPlayer> audioPlayer = AudioPlayer().obs;
  var timerController = TimerController().obs;
    final TextEditingController timerTextEditingController =
      TextEditingController();

  @override
  void onInit() {
    // audioPlayer = AudioPlayer().obs;
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

  // here are gonna use two different streams and we will combine them
  Stream<MusicSliderPositionData> get musicSliderDragPositionDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, MusicSliderPositionData>(
        audioPlayer.value.positionStream,
        audioPlayer.value.durationStream,
        (Duration position, Duration? duration) =>
            MusicSliderPositionData(position, duration ?? Duration.zero),
      );
}


