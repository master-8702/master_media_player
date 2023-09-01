import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/features/playlists/domain/playlist.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';


class PlaylistCard extends StatelessWidget {
  PlaylistCard({
    Key? key,
    required this.myPlaylist,
  }) : super(key: key);

  final Playlist myPlaylist;
  final playlistsController = Get.find<PlaylistsController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        playlistsController.selectedPlaylistToPlay.value =
            playlistsController.myPlaylists.indexOf(myPlaylist);
        Get.toNamed(
          'playlist',
          // arguments: {'playlist': myPlaylist, 'selectedIndex': 0}
        );
      },
      child: NeumorphicContainer(
        padding: 10,
        margin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: myPlaylist.coverImageUrl == 'assets/images/playlist.png'
                  ? Image.asset(
                      myPlaylist.coverImageUrl,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(myPlaylist.coverImageUrl),
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
            ),
            // this music player app is developed by master
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(myPlaylist.title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 16)),
                  const SizedBox(
                    height: 3,
                  ),
                  Text('${myPlaylist.songs.length} Songs',
                      style: Theme.of(context).textTheme.bodySmall)
                ],
              ),
            ),
            PopupMenuButton(
                position: PopupMenuPosition.under,
                onSelected: ((selectedValue) {
                  if (selectedValue == 'Delete  Playlist') {
                    playlistsController.addOrRemovePlaylists(myPlaylist);
                  }
                }),
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(
                      value: 'Delete  Playlist',
                      child: Text('Delete  Playlist'),
                    ),
                  ];
                })
          ],
        ),
      ),
    );
  }
}
