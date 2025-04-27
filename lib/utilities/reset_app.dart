import 'package:get/get.dart';

import 'package:mastermediaplayer/services/storage_service.dart';
import 'package:mastermediaplayer/common/controllers/theme_controller.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favorites_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';

/// This method will be used to reset all app settings and locally saved items
Future<void> resetApp() async {
  final favoritesController = Get.find<FavoritesController>();
  final playlistsController = Get.find<PlaylistsController>();
  final storageServices = Get.find<StorageService>();
  final themeController = Get.find<ThemeController>();

  // changing the theme back to the default - light theme
  themeController.resetTheme();
  // clearing saved favorite musics
  favoritesController.resetFavorites();
  // clearing playlists
  playlistsController.resetPlaylists();
  // clearing local persistent storage
  await storageServices.reset();
}
