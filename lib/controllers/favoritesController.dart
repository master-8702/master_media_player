import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../components/utilities/utilities.dart';
import '../models/song_model.dart';

// this class is going to be used as state manager (controller) for favorite musics
// it will be used mainly on homepage and partly on songPlyingScreen (favorite/unfavorite button part)

class FavoritesController extends GetxController {
  // the 'myFavoriteSongs' is list of songs ready to be displayed on home page
  // but the 'myFavorites' is a List of song urls(Strings) used to store the favorite musics on the local storage permanently
  // it is String because we can't store a list of Songs directly on the local storage using GetStorage, we can actually but
  // it gets messy when we start to read it as Songs.
  List<Song> myFavoriteSongs = [];
  List<dynamic> myFavorites = [];
  GetStorage box = GetStorage();

  // this method will initializes the 'myFavoriteSongs' and 'myFavorites' variables by reading from local storage
  void getFavoriteMusics() async {
    if (GetStorage().read('myFavorites') == null) {
      GetStorage().write('myFavorites', <String>[]);
    }
    myFavorites = GetStorage().read('myFavorites');
    if (myFavorites.isNotEmpty) {
      for (String s in myFavorites) {
        myFavoriteSongs.add(await Utilities().getSong(s));
      }
    }
    update();
  }

  // this method is used for adding new favorite music to the already existing list
  // and update the UI accordingly using the 'update' method of GetX state management (update will force the rebuilding of the UI)
  void addFavorites(Song music) {
    myFavoriteSongs.add(music);
    myFavorites.add(music.songUrl);

    box.write('myFavorites', myFavorites);

    update();
  }

  // this method is used for removing favorite music from the already existing list
  // and update the UI accordingly using the 'update' method of GetX state management (update will force the rebuilding of the UI)
  void removeFavorites(Song music) {
    myFavoriteSongs.remove(music);
    myFavorites.remove(music.songUrl);

    box.write('myFavorites', myFavorites);
    update();
  }
}
