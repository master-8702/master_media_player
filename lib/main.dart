import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:mastermediaplayer/routing/app_routes.dart';
import 'package:mastermediaplayer/services/storage_service.dart';
import 'package:mastermediaplayer/common/screens/home_screen.dart';
import 'package:mastermediaplayer/utilities/theme_configurations.dart';
import 'package:mastermediaplayer/common/controllers/theme_controller.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favorites_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';

void main() async {
  await GetStorage.init();
  // final box = GetStorage();
  // box.erase();

  // for running the app in the background (initialize just audio background)
  // it is also  used for playing audio in the background and for displaying
  // the notification when the app is in the background
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidNotificationIcon: 'mipmap/ic_launcher',
  );

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
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeController.currentThemeMode,
      home: const HomeScreen(),
      getPages: getPageRoutes(),
    );
  }
}
