import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/controllers/favoritesController.dart';
import 'package:mastermediaplayer/features/player/presentation/song_playing_screen_controller.dart';
import 'package:mastermediaplayer/models/song_model.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';

class SongPlayerBody extends StatelessWidget {
  const SongPlayerBody({
    super.key,
    required this.song,
    required this.controller,
  });

  final Song song;
  final SongPlayingScreenController controller;

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
                  child: song.coverImageUrl.length == 13
                      ? Image.asset(
                          'assets/images/music_icon5.png',
                          fit: BoxFit.fill,
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width,
                        )
                      : Image.memory(
                          song.coverImageUrl,
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
                        if (controller.timerController.value.duration.value >
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
                              '⏱ ${Utilities.formatDuration(controller.timerController.value.duration.value)}',
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
                        GetBuilder<FavoritesController>(
                            builder: (favoriteStateController) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (favoriteStateController.myFavorites
                                    .contains(song.songUrl)) {
                                  favoriteStateController.removeFavorites(song);
                                } else {
                                  favoriteStateController.addFavorites(song);
                                }
                              },
                              child: Icon(
                                favoriteStateController.myFavorites
                                        .contains(song.songUrl)
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
                        })
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
