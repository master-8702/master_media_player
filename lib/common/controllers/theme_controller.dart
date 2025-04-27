import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:mastermediaplayer/Constants/local_storage_keys.dart';

class ThemeController extends GetxController {
  final _localStorage = GetStorage();
  final _key = themeKey;

  /// getter for the current theme mode
  ThemeMode get currentThemeMode =>
      isDarkModeOn() ? ThemeMode.dark : ThemeMode.light;

  /// return true if dark mode is set to on otherwise false
  bool isDarkModeOn() {
    return _localStorage.read<bool>(_key) ?? false;
  }

  void changeThemeMode(ThemeMode themeMode) {
    // change the theme
    Get.changeThemeMode(themeMode);
    // then save the change to local storage
    if (themeMode == ThemeMode.dark) {
      _localStorage.write(_key, true);
    } else {
      _localStorage.write(_key, false);
    }
  }

  void resetTheme() {
    changeThemeMode(ThemeMode.light);
  }
}
