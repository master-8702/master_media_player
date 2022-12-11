import 'package:flutter/material.dart';
import 'package:mastermediaplayer/components/section_header.dart';
import 'package:mastermediaplayer/components/song_card.dart';

import '../models/song_model.dart';

class MyFavorites extends StatelessWidget {
  const MyFavorites({
    Key? key,
    required this.myFavoriteSongs,
  }) : super(key: key);

  final List<Song> myFavoriteSongs;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SectionHeader(title: "My Favorites"),
      const SizedBox(
        height: 25,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.27,
        child: ListView.builder(
            itemCount: myFavoriteSongs.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SongCard(song: myFavoriteSongs[index]);
            }),
      )
    ]);
  }
}
