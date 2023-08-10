import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mastermediaplayer/Constants/constants.dart';
import 'package:mastermediaplayer/utilities/configurations.dart';

class StorageService extends GetxService {
  late GetStorage _localStorage;

// instantiate the local storage if the app is opened for the first time
// or has been cleared
  Future<StorageService> init() async {
    _localStorage = GetStorage();
    await _localStorage.writeIfNull(kthemeKey, false);
    await _localStorage.writeIfNull(kplaylistsKey, []);
    await _localStorage.writeIfNull(kfavoritesKey, []);

  // returning the current GetStorage instance
    return this;
  }

  T read<T>(String key) {
    return _localStorage.read(key);
  }

  void write(String key, dynamic value) async {
    await _localStorage.write(key, value);
  }
}
