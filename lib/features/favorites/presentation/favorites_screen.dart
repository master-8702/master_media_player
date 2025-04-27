import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/features/favorites/presentation/song_card2.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favorites_header.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favorites_controller.dart';

// this class will build our favorites screen
class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final favoritesController = Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            const FavoritesHeader(),
            const SizedBox(
              height: 15,
            ),
            Obx(() => Expanded(
                child: ListView.builder(
                    clipBehavior: Clip.antiAlias,
                    itemCount: favoritesController.myFavoritesSongs.length,
                    itemBuilder: (context, index) {
                      var currentMusic =
                          favoritesController.myFavoritesSongs[index];
                      return SongCard2(song: currentMusic);
                    })))
          ]),
        ),
      ),
    );
  }
}
