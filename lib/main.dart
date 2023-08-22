import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:mastermediaplayer/controllers/theme_controller.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favoritesController.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favorites_screen.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/image_explorer_screen.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/music_explorer_screen.dart';
import 'package:mastermediaplayer/features/player/presentation/song_playing_screen.dart';
import 'package:mastermediaplayer/screens/create_playlist_screen.dart';
import 'package:mastermediaplayer/screens/home_screen.dart';
import 'package:mastermediaplayer/screens/playlists_screen.dart';
import 'package:mastermediaplayer/screens/searchScreen.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/selectable_song_explorer_screen.dart';
import 'package:mastermediaplayer/screens/settings_screen.dart';
import 'package:mastermediaplayer/screens/single_playlist_screen.dart';
import 'package:mastermediaplayer/services/storage_service.dart';
import 'package:mastermediaplayer/utilities/configurations.dart';

void main() async {
  await GetStorage.init();
  // final box = GetStorage();
  // box.erase();

  // initialize local storages and inject it into MyApp
  await Get.putAsync(() => StorageService().init());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

// Injecting dependencies
  final themeController = Get.put(ThemeController());
  final favoritesController = Get.put(FavoritesController());

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
          page: () => const SinglePlaylistScreen(),
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
          page: () => const SearchScreen(),
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
