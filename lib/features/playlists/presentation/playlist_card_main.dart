import 'dart:io';

import 'package:flutter/material.dart';

import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';
import 'package:mastermediaplayer/features/playlists/domain/playlist.dart';

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
            child: myPlaylist.coverImageUrl == 'assets/images/playlist.png'
                ? Image.asset(
                    myPlaylist.coverImageUrl,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.6,
                    fit: BoxFit.fill,
                  )
                : Image.file(
                    File(myPlaylist.coverImageUrl),
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.6,
                    fit: BoxFit.fill,
                  ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
