import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mastermediaplayer/screens/create_playlist_screen.dart';
import 'package:mastermediaplayer/screens/favorites_screen.dart';
import 'package:mastermediaplayer/screens/home_screen.dart';
import 'package:mastermediaplayer/screens/music_explorer_screen.dart';
import 'package:mastermediaplayer/screens/music_explorer_screen2.dart';
import 'package:mastermediaplayer/screens/music_explorer_screen3.dart';
import 'package:mastermediaplayer/screens/playlists_screen.dart';
import 'package:mastermediaplayer/screens/searchScreen.dart';
import 'package:mastermediaplayer/screens/settings_screen.dart';
import 'package:mastermediaplayer/screens/single_playlist_screen.dart';
import 'package:mastermediaplayer/screens/song_playing_screen.dart';
import 'package:mastermediaplayer/utilities/configurations.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of our application. that will handle the route and everything.
  @override
  Widget build(BuildContext context) {
    // here we will check the user's chosen theme mode from persistent local storage
    // and assign a proper theme accordingly, when starting the app
    var isDarkModeOn = GetStorage().read('isDarkModeOn') ?? false;

    return GetMaterialApp(
      title: 'Master Media Player',
      theme: isDarkModeOn ? darkTheme : lightTheme,
      home: const HomeScreen(),
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: '/songPlaying',
          page: () => const SongPlayingScreen(),
        ),
        GetPage(
          name: '/playlist',
          page: () => const SinglePlaylistScreen(),
        ),
        GetPage(
          name: '/explorer',
          page: () => const MusicExplorer(),
        ),
        GetPage(
          name: '/songExplorer2',
          page: () => const MusicExplorer2(),
        ),
        GetPage(
          name: '/pictureExplorer3',
          page: () => const MusicExplorer3(),
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
          page: () => const FavoritesScreen(),
        ),
        GetPage(
          name: '/search',
          page: () => const SearchScreen(),
        ),
        GetPage(
          name: '/settings',
          page: () => SettingsScreen(),
        ),
      ],
    );
  }
}
