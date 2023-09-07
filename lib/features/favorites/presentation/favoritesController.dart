import 'package:get/get.dart';

import 'package:mastermediaplayer/features/favorites/data/local_favorites_repository.dart';

import '../../../common/models/song_model.dart';

class FavoritesController extends GetxController {
  /// This class is going to be used as state manager (controller) for favorite musics
  /// it will be used mainly on homepage and partly on songPlyingScreen (favorite/unfavorite button part)

  final myFavoritesSongs = <Song>[].obs;

  final favoritesRepository = LocalFavoritesRepository();

  @override
  void onInit() {
    // This will initialize favorites list when the controller (dependency) is first
    // injected in the main.dart file
    myFavoritesSongs.assignAll(favoritesRepository.getFavoritesList());

    super.onInit();
  }

  // Getting a list of favorite musics
  void getFavoriteMusics() async {
    myFavoritesSongs.assignAll(favoritesRepository.getFavoritesList());
  }

  // Add or remove favorite musics
  void addOrRemoveFavorites(Song song) async {
    myFavoritesSongs.assignAll(favoritesRepository.addOrRemoveFavorites(song));
  }

  // reset favorites
  void resetFavorites() {
    myFavoritesSongs.assignAll(favoritesRepository.clearFavorites());
  }
}
