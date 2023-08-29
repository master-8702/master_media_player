import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import 'package:mastermediaplayer/features/player/domain/music_slider_position_data.dart';
import 'package:mastermediaplayer/features/playlists/domain/playlist_model.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller2.dart';


class SinglePlaylistScreenController extends GetxController {
  final playlistController = Get.find<PlaylistsController2>();

  late Rx<Playlist> myPlaylist = playlistController
      .myPlaylists[playlistController.selectedPlaylistToPlay.value]
      .obs; // = Get.arguments['playlist'].obs;
  // playing song index
  var currentAudioPlayerIndex = 0.obs;

  late final AudioPlayer audioPlayer = playlistController.audioPlayer;
  // selected playlist index
  late RxInt currentPlaylistIndex = 0.obs;
  //  late Playlist currentPlaylist;
  var audioSources = <AudioSource>[];
  // multiple audio sources for the playlist
  late ConcatenatingAudioSource concatenatedAudioSources;

  // last played song index and position
  int lastIndex = 0;
  Duration lastPosition = Duration.zero;

  @override
  void onInit() async {
    // currentAudioPlayerIndex.value = selectedSongIndex.value;
    currentAudioPlayerIndex.value = audioPlayer.currentIndex ?? 0;

    // here we are updating the [SinglePlaylistScreenController]'s myPlaylist variable whenever the
    // [PlaylistControllers]'s myPlaylists is changed.
    ever(playlistController.myPlaylists, (List<Playlist> value) async {
      // update the playlist
      myPlaylist.value = value[playlistController.selectedPlaylistToPlay.value];
      // refresh .. to update the UI (some custom class instances needs manual refresh )
      myPlaylist.refresh();
      // save current playing song index and position (current playing position)
      saveCurrentStatus();
      // update the audio source with the new changes
      await refreshAudioSource();
    });

    await initializeAudioSource();

    super.onInit();
  }

  Future<void> initializeAudioSource() async {
    // converting playlist to [AudioSource]
    for (String songPath in myPlaylist.value.songs) {
      audioSources.addIf(!audioSources.contains(AudioSource.file(songPath)),
          AudioSource.file(songPath));
    }
    // adding the audio sources to the [ConcatenatingAudioSource]
    concatenatedAudioSources = ConcatenatingAudioSource(
        children: audioSources,
        shuffleOrder: DefaultShuffleOrder(),
        useLazyPreparation: true);
    // adding the [ConcatenatingAudioSource] to the [audioPlayer]
    await audioPlayer.setAudioSource(concatenatedAudioSources,
        initialIndex: lastIndex, initialPosition: lastPosition);
  }


  // Future<void> updateAudioSource() async {
  //   var temp = <AudioSource>[];
  //   for (String songUrl in myPlaylist.value.songs) {
  //     temp.addIf(!audioSources.contains(AudioSource.file(songUrl)),
  //         AudioSource.file(songUrl));
  //   }
  //   audioSources.assignAll(temp);
  //   await concatenatedAudioSources.addAll(audioSources);
  // }


// here we are updating audio source when a song is added or removed from the playlist
// and we are forced to delete and recreate another ConcatenatingAudioSource instance
// to reflect the new changes, because we can not update the first [ConcatenatingAudioSource]
// instance, the library is giving us 'can not modify list during iteration' kind of error
// whenever we try to modify that list using concatenatedAudioSources.addAll() method. 
  Future<void> refreshAudioSource() async {
    audioSources.clear();

    for (String songUrl in myPlaylist.value.songs) {
      audioSources.addIf(!audioSources.contains(AudioSource.file(songUrl)),
          AudioSource.file(songUrl));
    }

    concatenatedAudioSources = ConcatenatingAudioSource(
        children: audioSources,
        shuffleOrder: DefaultShuffleOrder(),
        useLazyPreparation: true);

    await audioPlayer.setAudioSource(concatenatedAudioSources,
        initialIndex: lastIndex, initialPosition: lastPosition);
  }
// saving the current playing song index and song position
  void saveCurrentStatus() {
    lastIndex = audioPlayer.currentIndex ?? currentAudioPlayerIndex.value;
    lastPosition = audioPlayer.position;
  }


  Stream<MusicSliderPositionData> get musicSliderDragPositionDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, MusicSliderPositionData>(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
        (Duration position, Duration? duration) =>
            MusicSliderPositionData(position, duration ?? Duration.zero),
      );
}
