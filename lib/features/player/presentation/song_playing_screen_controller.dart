import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:just_audio_background/just_audio_background.dart';

import 'package:mastermediaplayer/common/models/song_model.dart';
import 'package:mastermediaplayer/utilities/generate_artwork_Uri.dart';
import 'package:mastermediaplayer/utilities/extract_embedded_artwork.dart';
import 'package:mastermediaplayer/common/controllers/timerController.dart';
import 'package:mastermediaplayer/features/player/domain/music_slider_position_data.dart';

// this class is going to be used for controlling the single song player page UI
class SongPlayingScreenController extends GetxController {
  // here [Get.arguments] is used for getting data passed from the previous page
  // eg. from home page when we click one favorite music to the song playing screen and
  // this controller [SongPlayingScreenController] is inside song playing screen.
  final Song song = Get.arguments;

  late final List<Song> songList;
  late final Rx<AudioPlayer> audioPlayer = AudioPlayer().obs;
  final Rx<TimerController> timerController = TimerController().obs;
  final TextEditingController timerTextEditingController =
      TextEditingController();
  final RxString artUri = ''.obs;

  @override
  void onInit() {
    songList = [song];
    initialize();

    super.onInit();
  }

  @override
  void onClose() {
    audioPlayer.value.dispose();
    artUri.value = '';
    super.onClose();
  }

  Future<void> initialize() async {
    try {
      await _initializeAlbumArt();

      await audioPlayer.value
          .setAudioSource(AudioSource.uri(Uri.file(songList.first.songUrl),
              tag: MediaItem(
                id: songList.indexOf(songList.first).toString(),
                title: songList.first.title,
                // artist: songList.first.artist,
                // artUri: Uri.file(songList.first.coverImageUrl.toString() ),
                artUri: Uri.parse(artUri.value),
              )));
    } catch (e) {
      if (!kReleaseMode) {
        debugPrint("Error loading audio source: $e");
      }
    }
  }

  // this function is used to initialize the albumArt for the song
  // and it will be called when the song is loaded.
  // since the MediaItem reads from storage we can't just pass the image bytes
  // to the MediaItem object.
  Future<void> _initializeAlbumArt() async {
    try {
      // here we are going to extract the embedded artwork from the audio file
      final embeddedArtwork =
          await extractEmbeddedArtwork(File(songList.first.songUrl));

      // here we are going to generate the artwork uri from the embedded artwork
      artUri.value = (await generateArtworkUri(
        fallbackAssetPath: 'assets/images/music_icon5.png',
        embeddedArtwork: embeddedArtwork,
      ))
          .toString();
    } catch (e) {
      if (!kReleaseMode) {
        debugPrint('Error initializing album art: ${e.toString()}');
      }
    }
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
