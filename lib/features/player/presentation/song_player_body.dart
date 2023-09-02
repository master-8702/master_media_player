import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favoritesController.dart';
import 'package:mastermediaplayer/features/player/presentation/song_playing_screen_controller.dart';
import 'package:mastermediaplayer/common/models/song_model.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';

class SongPlayerBody extends StatelessWidget {
  const SongPlayerBody({
    super.key,
    required this.song,
    required this.songPlayingScreenController,
    required this.favoritesController,
  });

  final Song song;
  final SongPlayingScreenController songPlayingScreenController;
  final FavoritesController favoritesController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.52,
      width: MediaQuery.of(context).size.width,
      child: NeumorphicContainer(
        padding: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Stack(alignment: Alignment.topCenter, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: song.coverImageUrl?.length == 13
                      ? Image.asset(
                          'assets/images/music_icon5.png',
                          fit: BoxFit.fill,
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width,
                        )
                      : Image.memory(
                          song.coverImageUrl as Uint8List,
                          fit: BoxFit.fill,
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        if (songPlayingScreenController
                                .timerController.value.duration.value >
                            Duration.zero) {
                          return Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                              color: Theme.of(context).backgroundColor,
                            ),
                            child: Text(
                              '⏱ ${Utilities.formatDuration(songPlayingScreenController.timerController.value.duration.value)}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        } else {
                          return const Text('');
                        }
                      }),
                    ],
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextScroll(
                      velocity: const Velocity(pixelsPerSecond: Offset(30, 30)),
                      song.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextScroll(
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(30, 30)),
                            song.artist,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 16),
                          ),
                        ),
                        Obx(() {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                // here we will add or remove the current song on the favorites list
                                favoritesController.addOrRemoveFavorites(song);
                              },
                              child: Icon(
                                favoritesController.myFavoritesSongs
                                        .contains(song)
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 32,
                                shadows: [
                                  BoxShadow(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
