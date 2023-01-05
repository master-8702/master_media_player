import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/controllers/playlistsController.dart';

import '../models/playlist_model.dart';

class PlaylistCard extends StatelessWidget {
  PlaylistCard({
    Key? key,
    required this.myPlaylist,
  }) : super(key: key);

  final Playlist myPlaylist;
  final PlaylistsController playlistsController =
      Get.put(PlaylistsController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('playlist', arguments: myPlaylist);
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    myPlaylist.title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text('${myPlaylist.songs.length} Songs',
                      style: Theme.of(context).textTheme.bodySmall!)
                ],
              ),
            ),
            PopupMenuButton(onSelected: ((selectedValue) {
              if (selectedValue == 'Delete  Playlist') {
                playlistsController.removePlaylist(myPlaylist);
              }
            }), itemBuilder: (context) {
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
