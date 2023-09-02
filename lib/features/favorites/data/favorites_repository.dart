import 'package:mastermediaplayer/common/models/song_model.dart';

abstract class FavoritesRepository {
  /// This is an abstract class for our favorites list repository

  List<Song> getFavoritesList();
  addOrRemoveFavorites(Song song);
}
