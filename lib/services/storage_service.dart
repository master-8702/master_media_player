import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:mastermediaplayer/Constants/local_storage_keys.dart';
import 'package:mastermediaplayer/features/playlists/domain/playlist.dart';
import 'package:mastermediaplayer/common/models/song_model.dart';

/// This is a local repository for our storage service
/// it will be used to store and retrieve data from local storage
/// using the GetStorage package
class StorageService extends GetxService {
  late GetStorage _localStorage = GetStorage();

// instantiate the local storage if the app is opened for the first time
// or has been cleared
  Future<StorageService> init() async {
    _localStorage = GetStorage();
    await _localStorage.writeIfNull(themeKey, false);
    await _localStorage.writeIfNull(playlistsKey, <Playlist>[]);
    await _localStorage.writeIfNull(favoritesKey, <Song>[]);

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

  // erasing and re-initializing storages to reset the app
  Future<void> reset() async {
    await _localStorage.erase();
    await init();
  }
}
