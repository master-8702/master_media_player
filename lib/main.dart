import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:mastermediaplayer/common/controllers/theme_controller.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favoritesController.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/common/screens/home_screen.dart';
import 'package:mastermediaplayer/routing/app_routes.dart';
import 'package:mastermediaplayer/services/storage_service.dart';
import 'package:mastermediaplayer/utilities/theme_configurations.dart';

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
      getPages: getPageRoutes(),
    );
  }
}
