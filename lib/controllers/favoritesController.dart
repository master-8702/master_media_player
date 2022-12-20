import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../components/utilities/utilities.dart';
import '../models/song_model.dart';

class FavoritesController extends GetxController {
  List<Song> myFavoriteSongs = [];
  GetStorage box = GetStorage();

  void getFavoriteMusics() async {
    if (GetStorage().read('myFavorites') == null) {
      GetStorage().write('myFavorites', <String>[]);
    }
    List<dynamic> myFavoriteTemp = GetStorage().read('myFavorites');
    if (myFavoriteTemp.isNotEmpty) {
      for (String s in myFavoriteTemp) {
        myFavoriteSongs.add(await Utilities().getSong(s));
      }
    }
    update();
  }

  void addFavorites(Song music) {
    myFavoriteSongs.add(music);
    box.write('myFavorites', myFavoriteSongs);

    update();
  }

  void removeFavorites(Song music) {
    myFavoriteSongs.remove(music);
    box.write('myFavorites', myFavoriteSongs);

    update();
  }
}
