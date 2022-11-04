import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:mastermediaplayer/screens/home_screen.dart';
import 'package:mastermediaplayer/screens/playlist_screen.dart';
import 'package:mastermediaplayer/screens/song_playing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
      ],
    );
  }
}
