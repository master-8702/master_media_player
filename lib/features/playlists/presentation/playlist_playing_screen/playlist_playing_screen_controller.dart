import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:just_audio_background/just_audio_background.dart';

import 'package:mastermediaplayer/utilities/generate_artwork_uri.dart';
import 'package:mastermediaplayer/features/playlists/domain/playlist.dart';
import 'package:mastermediaplayer/features/player/domain/music_slider_position_data.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';

// this controller is used to control the audio player and the playlist in the
// playlist playing screen
class PlaylistPlayingScreenController extends GetxController {
  static var playlistController = Get.find<PlaylistsController>();

  Rx<Playlist> myPlaylist =
      Rx(Playlist(title: '', songs: [], coverImageUrl: ''));

  // = Get.arguments['playlist'].obs;

  // playing song index
  // here Get.arguments is used when the playlist screen is created by selecting a search result
  RxInt currentAudioPlayerIndex =
      RxInt(Get.arguments != null ? Get.arguments['selectedIndex'] : 0);
  // last played song
  RxString lastSong = ''.obs;

  final AudioPlayer audioPlayer = AudioPlayer();

  var audioSources = <AudioSource>[];
  // multiple audio sources for the playlist
  // late ConcatenatingAudioSource concatenatedAudioSources;

  // last played song index and position
  // here Get.arguments is used when the playlist screen is created by selecting a search result
  // so that the selected index will be passed back from the search screen and
  // we will get and play that specific playlist song index
  int lastIndex = Get.arguments != null ? Get.arguments['selectedIndex'] : 0;
  Duration lastPosition = Duration.zero;

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    // if playlist is passed from the previous screen,
    // e.g: when clicking a playlist search result from homepage
    if (Get.arguments != null) {
      myPlaylist.value = Get.arguments['playlist'];
      // to start playing the song automatically when the user presses a song from a search result
      // in other cases the user needs to click the play button to start playing the song(s)
      audioPlayer.play();
    } else {
      // if not
      myPlaylist.value = playlistController
          .myPlaylists[playlistController.selectedPlaylistToPlay.value];
    }

    // here we are listening to changes for the [playlistController.myPlaylists] variable
    // that is found inside the Playlist controller class.
    // And on every change we will update our [myPlaylist] variable accordingly and
    // update the audio source that we assign for the audio player instance as well.
    playlistController.myPlaylists.listen(
      (value) async {
        if (value.isNotEmpty) {
          currentAudioPlayerIndex.value = playlistController
              .myPlaylists[playlistController.selectedPlaylistToPlay.value]
              .songs
              .indexOf(lastSong.value);

          myPlaylist.value = playlistController
              .myPlaylists[playlistController.selectedPlaylistToPlay.value];
          // refresh .. to update the UI (some custom class instances needs manual refresh )
          myPlaylist.refresh();
          // save current playing song index and position (current playing position)
          saveCurrentStatus();
          // update the audio source with the new changes
          await updateAudioSource();
        }
      },
    );

    // ever(myPlaylist, (callback) {
    //   if (currentAudioPlayerIndex.value > myPlaylist.value.songs.length) {
    //     currentAudioPlayerIndex.value = myPlaylist.value.songs.length-1;
    //   }
    // });

    // here we update the [lastSong] whenever the [audioPlayer] current index changes
    audioPlayer.currentIndexStream.listen((value) {
      if (value != null) {
        lastSong.value = myPlaylist.value.songs[value];
      }
    });
    // to initialize the audio sources for the first time
    await updateAudioSource();

    super.onInit();
  }

// here we are updating audio source when a song is added or removed from the playlist
// and we are forced to delete and recreate another ConcatenatingAudioSource instance
// to reflect the new changes, because we can not update the first [ConcatenatingAudioSource]
// instance, the library is giving us 'can not modify list during iteration' kind of error
// whenever we try to modify that list using concatenatedAudioSources.addAll() method.
  Future<void> updateAudioSource() async {
    // clear the previous audio sources
    audioSources.clear();
    Uri playlistCoverUri;

    playlistCoverUri = await generateArtworkUri(
      customCoverImagePath: myPlaylist.value.coverImageUrl,
      fallbackAssetPath: 'assets/images/playlist.png',
    );

    // create the new audio sources from the playlist
    for (String songUrl in myPlaylist.value.songs) {
      audioSources.addIf(
          !audioSources.contains(AudioSource.file(songUrl,
              tag: MediaItem(
                id: songUrl,
                title: songUrl.split('/').last,
                artist: 'Unknown Artist',
                artUri: playlistCoverUri,
              ))),
          AudioSource.file(songUrl,
              tag: MediaItem(
                id: songUrl,
                title: songUrl.split('/').last,
                artist: 'Unknown Artist',
                artUri: playlistCoverUri,
              )));
    }
    // set the AudioSources to the AudioPlayer instance
    await audioPlayer.setAudioSources(audioSources,
        initialIndex: lastIndex, initialPosition: lastPosition);
  }

// saving the current playing song index and song position
  void saveCurrentStatus() {
    lastIndex = currentAudioPlayerIndex.value;
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
