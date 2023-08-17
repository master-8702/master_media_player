import 'package:mastermediaplayer/models/song_model.dart';

abstract class FavoritesRepository {
  Future<List<Song>> getFavoritesList();
  Future<bool> addFavorite(Song song);
  Future<bool> removeFavorite(Song song);
}
