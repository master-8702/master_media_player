import 'package:flutter/material.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';

import '../models/playlist_model.dart';

class PlaylistCardMain extends StatelessWidget {
  const PlaylistCardMain({
    Key? key,
    required this.myPlaylist,
  }) : super(key: key);

  final Playlist myPlaylist;

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      padding: 10,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              myPlaylist.coverImageUrl,
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.6,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            myPlaylist.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
