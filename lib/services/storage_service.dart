import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:mastermediaplayer/Constants/constants.dart';
import 'package:mastermediaplayer/features/playlists/domain/playlist.dart';
import 'package:mastermediaplayer/models/song_model.dart';

class StorageService extends GetxService {
  late GetStorage _localStorage = GetStorage();

// instantiate the local storage if the app is opened for the first time
// or has been cleared
  Future<StorageService> init() async {
    _localStorage = GetStorage();
    await _localStorage.writeIfNull(kthemeKey, false);
    await _localStorage.writeIfNull(kplaylistsKey, <Playlist>[]);
    await _localStorage.writeIfNull(kfavoritesKey, <Song>[]);

    // returning the current GetStorage instance
    return this;
  }

// reading from the current get instance using key
  T read<T>(String key) {
    return _localStorage.read(key);
  }

// writing to the current get instance using key
  void write(String key, dynamic value) async {
    await _localStorage.write(key, value);
  }
}
