import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favoritesController.dart';
import 'package:mastermediaplayer/routing/app_routes.dart';

import '../../../common/models/song_model.dart';

class SongCard2 extends StatelessWidget {
  SongCard2({
    Key? key,
    required this.song,
  }) : super(key: key);

  final Song song;
  final favoritesController = Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoute.songPlayingScreen.path, arguments: song);
      },
      child: NeumorphicContainer(
        padding: 10,
        margin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: song.coverImageUrl?.length == 13
                  ? Image.asset(
                      'assets/images/music_icon5.png',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    )
                  : Image.memory(
                      song.coverImageUrl as Uint8List,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(song.artist,
                      style: Theme.of(context).textTheme.bodySmall!),
                  Text(song.albumTitle,
                      style: Theme.of(context).textTheme.bodySmall!),
                ],
              ),
            ),
            PopupMenuButton(
                position: PopupMenuPosition.under,
                onSelected: ((selectedValue) {
                  // this music player app is developed by master
                  if (selectedValue == 'Remove  from favorites') {
                    favoritesController.addOrRemoveFavorites(song);
                  }
                }),
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(
                      value: 'Remove  from favorites',
                      child: Text('Remove  from favorites'),
                    ),
                  ];
                })
          ],
        ),
      ),
    );
  }
}
