import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/components/song_card2.dart';
import 'package:mastermediaplayer/controllers/favoritesController.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favorites_header.dart';

class FavoritesScreen2 extends StatelessWidget {
  FavoritesScreen2({super.key});

  final FavoritesController favoritesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            FavoritesHeader(),
            const SizedBox(
              height: 15,
            ),
            Obx(() => Expanded(
                child: ListView.builder(
                    clipBehavior: Clip.antiAlias,
                    itemCount: favoritesController.myFavorites.length,
                    itemBuilder: (context, index) {
                      var currentMusic =
                          favoritesController.myFavoriteSongs[index];
                      return SongCard2(song: currentMusic);
                    })))
          ]),
        ),
      ),
    );
  }
}
