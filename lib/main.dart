import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:mastermediaplayer/common/controllers/theme_controller.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favoritesController.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favorites_screen.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/image_explorer_screen.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/music_explorer_screen.dart';
import 'package:mastermediaplayer/features/player/presentation/song_playing_screen.dart';
import 'package:mastermediaplayer/features/playlists/presentation/create_playlist_screen/create_playlist_screen.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_screen.dart';
import 'package:mastermediaplayer/common/screens/home_screen.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_search/playlist_search_screen.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/selectable_song_explorer_screen.dart';
import 'package:mastermediaplayer/common/screens/settings_screen.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen.dart';
import 'package:mastermediaplayer/services/storage_service.dart';
import 'package:mastermediaplayer/utilities/configurations.dart';

void main() async {
  await GetStorage.init();
  // final box = GetStorage();
  // box.erase();

  // Injecting dependencies
  // initialize local storages and inject it into MyApp
  await Get.putAsync(() => StorageService().init());
  Get.put(FavoritesController());
  Get.put(PlaylistsController());
  Get.put(ThemeController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final themeController = Get.find<ThemeController>();

  // This widget is the root of our application. that will handle the route and everything.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Master Media Player',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeController.currentThemeMode,
      home: const HomeScreen(),
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: '/songPlaying',
          page: () => SongPlayingScreen(),
        ),
        GetPage(
          name: '/playlist',
          page: () => const PlaylistPlayingScreen(),
        ),
        GetPage(
          name: '/fileExplorer',
          page: () => const MusicExplorerScreen(),
        ),
        GetPage(
          name: '/selectableSongExplorer',
          page: () => const SelectableSongExplorerScreen(),
        ),
        GetPage(
          name: '/imageExplorer',
          page: () => ImageExplorerScreen(),
        ),
        GetPage(
          name: '/playlists',
          page: () => PlaylistsScreen(),
        ),
        GetPage(
          name: '/createPlaylist',
          page: () => CreatePlaylistScreen(),
        ),
        GetPage(
          name: '/favorites',
          page: () => FavoritesScreen(),
        ),
        GetPage(
          name: '/search',
          page: () =>  PlaylistSearchScreen(),
        ),
        GetPage(
          name: '/settings',
          // this is for testing purposes we will return the correct page
          page: () => SettingsScreen(),
        ),
      ],
    );
  }
}
