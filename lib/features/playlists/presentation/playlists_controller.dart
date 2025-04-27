import 'package:get/get.dart';

import 'package:mastermediaplayer/features/playlists/domain/playlist.dart';
import 'package:mastermediaplayer/features/playlists/data/local_playlists_repository.dart';

/// this class is going to be used as state manager (controller) for playlists
/// it will be used mainly on homepage and myPlaylistsPage
class PlaylistsController extends GetxController {
// for managing the single playlist screen

  // AudioPlayer audioPlayer = AudioPlayer();

  RxList<Playlist> myPlaylists = <Playlist>[].obs;

  var selectedPlaylistToPlay = 0.obs;

  // variables needed while creating a new playlist
  RxList<String> selectedSongs = <String>[].obs;
  RxString selectedCoverImage = ''.obs;

  final playlistsRepository = LocalPlaylistsRepository();
  // this method will initializes the playlists by reading from local storage

  @override
  void onInit() {
    // initializing playlists list while creating the controller
    myPlaylists.assignAll(playlistsRepository.getPlaylistsList());

    super.onInit();
  }

  @override
  void onClose() {
    // audioPlayer.dispose();
    super.onClose();
  }

  void getPlaylistsList() {
    myPlaylists.assignAll(playlistsRepository.getPlaylistsList());
  }

  void addOrRemovePlaylists(Playlist playlist) {
    myPlaylists.assignAll(playlistsRepository.addOrRemovePlaylist(playlist));
  }

  void addSongsToPlaylist(Playlist playlist, List<String> songUrls) {
    myPlaylists
        .assignAll(playlistsRepository.addSongsToPlaylist(playlist, songUrls));
  }

  void removeSongsFromPlaylist(Playlist playlist, List<String> songUrls) {
    myPlaylists.assignAll(
        playlistsRepository.removeSongsFromPlaylist(playlist, songUrls));
  }

  void createPlaylist({required String title}) async {
    myPlaylists.assignAll(
      await playlistsRepository.createPlaylist(
        title: title,
        selectedCoverImage: selectedCoverImage.value,
        selectedSongsUrls: selectedSongs,
      ),
    );

    // resetting used variables for the next use
    selectedSongs = <String>[].obs;
    selectedCoverImage = ''.obs;
  }

  // reset playlists list
  void resetPlaylists() {
    myPlaylists.assignAll(playlistsRepository.clearPlaylists());
    selectedPlaylistToPlay = 0.obs;
  }
}
