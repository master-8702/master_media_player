import 'package:mastermediaplayer/Constants/constants.dart';
import 'package:mastermediaplayer/features/favorites/data/favorites_repository.dart';
import 'package:mastermediaplayer/models/song_model.dart';
import 'package:mastermediaplayer/services/storage_service.dart';

class LocalFavoritesRepository extends FavoritesRepository {
  List<Song> myFavoriteSongs = [];
  final ss = StorageService();
  @override
  Future<bool> addFavorite(Song song) async {
    if (!myFavoriteSongs.contains(song)) {
      myFavoriteSongs.add(song);
      List<Map<String, dynamic>> tempSongs = [];
      for (Song s in myFavoriteSongs) {
        tempSongs.add(s.toMap());
      }
      ss.write(kfavoritesKey, tempSongs);
    }
    return true;
  }

  @override
  Future<List<Song>> getFavoritesList() {
    final myFavorites = ss.read(kfavoritesKey);
    if (myFavorites.isNotEmpty) {
      for (String s in myFavorites) {
        myFavoriteSongs.add(Song.fromJson(s));
      }

      return Future.value(myFavoriteSongs);
    }
    return Future.value([]);
  }

  @override
  Future<bool> removeFavorite(Song song) async {
    if (myFavoriteSongs.contains(song)) {
      myFavoriteSongs.remove(song);
      List<Map<String, dynamic>> tempSongs = [];
      for (Song s in myFavoriteSongs) {
        tempSongs.add(s.toMap());
      }
      ss.write(kfavoritesKey, tempSongs);

    }
    return true;
  }
}
