import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mastermediaplayer/screens/home_screen.dart';
import 'package:mastermediaplayer/screens/music_explorer_screen.dart';
import 'package:mastermediaplayer/screens/playlist_screen.dart';
import 'package:mastermediaplayer/screens/song_playing_screen.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Master Media Player',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
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
          page: () => const PlaylistScreen(),
        ),
        GetPage(
          name: '/explorer',
          page: () => const MusicExplorer(),
        ),
      ],
    );
  }
}
