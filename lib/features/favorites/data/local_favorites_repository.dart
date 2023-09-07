import 'package:get/get.dart';

import 'package:mastermediaplayer/Constants/local_storage_keys.dart';
import 'package:mastermediaplayer/features/favorites/data/favorites_repository.dart';
import 'package:mastermediaplayer/common/models/song_model.dart';
import 'package:mastermediaplayer/services/storage_service.dart';

class LocalFavoritesRepository extends FavoritesRepository {
  /// This is a local repository for our favorites list

  List<Song> myFavoriteSongs = [];
  final ss = Get.find<StorageService>();

  @override
  List<Song> getFavoritesList() {
    final favoritesJson = ss.read(kfavoritesKey);

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
    ss.write(kfavoritesKey, jsonSongs);
    return myFavoriteSongs;
  }

// clear fvorites repository
  List<Song> clearFavorites() {
    myFavoriteSongs.clear();
    return myFavoriteSongs;
  }
}
