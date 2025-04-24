import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:path_provider/path_provider.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:mastermediaplayer/common/controllers/timerController.dart';
import 'package:mastermediaplayer/features/player/domain/music_slider_position_data.dart';
import 'package:mastermediaplayer/common/models/song_model.dart';

// this class is going to be used for controlling the single song player page UI 
class SongPlayingScreenController extends GetxController {
  // here [Get.arguments] is used for getting data passed from the previous page
  // eg. from home page when we click one favorite music to the song playing screen and
  // this controller [SongPlayingScreenController] is inside song playing screen.
  final Song song = Get.arguments;

  late final List<Song> songList;
  late final Rx<AudioPlayer> audioPlayer = AudioPlayer().obs;
  final Rx<TimerController> timerController = TimerController().obs;
  final TextEditingController timerTextEditingController = TextEditingController();
  final RxString artUri = ''.obs;

  @override
  void onInit()  {
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
      print("Error loading audio source: $e");
    }
  }

  // this function is used to initialize the albumArt for the song
  // and it will be called when the song is loaded.
  // it will extract the embedded artwork from the audio file and save it to a temporary file
  // and then set the artUri to the temporary file uri. we save the albumArt because
  // in order to display the albumArt in the notification bar and lock screen
  // we need to set the artUri to the MediaItem object. and it reads from storage
  // we can't ust pass the image bytes to the MediaItem object.
  Future<void> _initializeAlbumArt() async {
    // generate a unique name for the artwork file using timestamp
    // this is used to avoid caching issue (cover image not updating)
    final tr = DateTime.now().microsecondsSinceEpoch.toString();

    try {
      final tempDir = await getTemporaryDirectory();
      final artworkFile = File('${tempDir.path}/$tr.jpg');

      final artwork =
          await _extractEmbeddedArtwork(File(songList.first.songUrl));
      await artworkFile.writeAsBytes(artwork);
      artUri.value = artworkFile.uri.toString();
    } catch (e) {
      artUri.value =
          'asset:///${Uri.encodeComponent('assets/images/music_icon5.png')}';
    }
  }

  // this function is used to extract the embedded artwork from the audio file
  // and return it as a Uint8List. and if there isn't any embedded artwork
  // then we will return the default artwork.
  Future<Uint8List> _extractEmbeddedArtwork(File audioFile) async {
    try {
      // Use audio_metadata_reader package [[2]]
      final metadata = readMetadata(audioFile, getImage: true);

      if (metadata.pictures.isNotEmpty) {
        return metadata.pictures.first.bytes;
      }
    } catch (e) {
      print('error: ${e.toString()}');

      // Fallback if extraction fails
    }

    // Return default artwork if no embedded art found
    return (await rootBundle.load('assets/images/music_icon5.png'))
        .buffer
        .asUint8List();
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
