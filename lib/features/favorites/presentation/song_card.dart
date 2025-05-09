import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/routing/app_routes.dart';
import 'package:mastermediaplayer/common/models/song_model.dart';
import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    Key? key,
    required this.song,
  }) : super(key: key);

  final Song song;

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      padding: 10,
      margin: 5,
      child: Stack(alignment: Alignment.bottomCenter, children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                // length 13 means the music fie doesn't have an album art
                image: song.coverImageUrl?.length == 13
                    ? Image.asset('assets/images/music_icon5.png').image
                    : Image.memory(song.coverImageUrl as Uint8List).image,
                fit: BoxFit.fill),
          ),
        ),
        InkWell(
          onTap: () {
            Get.toNamed(AppRoute.songPlayingScreen.path, arguments: song);
          },
          child: Container(
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            padding: const EdgeInsets.all(8),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // this SizedBox is added in order to stop the texts from over flowing
                // and to achieve that we have to set the width for the text holder widget
                // this music player app is developed by master
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          overflow: TextOverflow.ellipsis,
                          song.title,
                          style: Theme.of(context).textTheme.titleSmall),
                      Text(song.artist,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
                const Icon(
                  Icons.play_circle,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
