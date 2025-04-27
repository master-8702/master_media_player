import 'package:get/get.dart';

import 'package:mastermediaplayer/common/models/song_model.dart';
import 'package:mastermediaplayer/services/storage_service.dart';
import 'package:mastermediaplayer/Constants/local_storage_keys.dart';
import 'package:mastermediaplayer/features/favorites/data/favorites_repository.dart';

/// This is a local repository for our favorites list
class LocalFavoritesRepository extends FavoritesRepository {

  List<Song> myFavoriteSongs = [];
  final ss = Get.find<StorageService>();

  @override
  List<Song> getFavoritesList() {
    final favoritesJson = ss.read(favoritesKey);

    if (favoritesJson != null && favoritesJson.isNotEmpty) {
      for (var s in favoritesJson) {
        myFavoriteSongs.add(Song.fromJson(s));
      }

      return myFavoriteSongs;
    }

    return [];
  }

  @override
  List<Song> addOrRemoveFavorites(Song song) {
    // counter++;

    if (myFavoriteSongs.contains(song)) {
      myFavoriteSongs.remove(song);
    } else {
      myFavoriteSongs.add(song);
    }
    var jsonSongs = [];
    for (Song s in myFavoriteSongs) {
      jsonSongs.add(s.toJson());
    }
    ss.write(favoritesKey, jsonSongs);
    return myFavoriteSongs;
  }

// clear favorites repository
  List<Song> clearFavorites() {
    myFavoriteSongs.clear();
    return myFavoriteSongs;
  }
}
