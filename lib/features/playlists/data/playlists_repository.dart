import 'package:mastermediaplayer/features/playlists/domain/playlist.dart';

abstract class PlaylistsRepository {
  /// This is an abstract class for our playlists list repository

  List<Playlist> getPlaylistsList();
  List<Playlist> addOrRemovePlaylist(Playlist playlist);
  List<Playlist> addSongsToPlaylist(Playlist playlist, List<String> songUrls);
  List<Playlist> removeSongsFromPlaylist(
      Playlist playlist, List<String> songUrls);
  Future<List<Playlist>> createPlaylist(
      {required String title,
      required String selectedCoverImage,
      required List<String> selectedSongsUrls});
}
