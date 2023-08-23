import 'package:mastermediaplayer/features/playlists/domain/playlist_model.dart';
import 'package:mastermediaplayer/models/song_model.dart';

abstract class PlaylistsRepository {
  /// This is an abstract class for our playlists list repository

  List<Playlist> getPlaylistsList();
  List<Playlist> addOrRemovePlaylist(Playlist playlist);
  List<Playlist> addOrRemoveSongsFromPlaylist(Playlist playlist, List<Song> songs);
}
