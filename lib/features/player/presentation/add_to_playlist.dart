import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/models/song_model.dart';

Future<dynamic> addToPlaylist(
    BuildContext context, PlaylistsController playlistsController, Song song) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: const Text('Add To Playlist'),
          content: playlistsController.myPlaylists.isEmpty
              ? const Center(
                  child: Text('No Playlists Yet!'),
                )
              : GetBuilder<PlaylistsController>(builder: (context) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: playlistsController.myPlaylists.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          // here we will add the music to a playlist
                          playlistsController.addOrRemoveSongsFromPlaylist(
                              playlistsController.myPlaylists[index],
                              [song.songUrl]);
                        },
                        trailing: const Icon(
                          Icons.add_circle,
                          size: 34,
                        ),
                        title:
                            Text(playlistsController.myPlaylists[index].title),
                        subtitle: Text(
                            '${playlistsController.myPlaylists[index].songs.length} songs'),
                      );
                    },
                  );
                }),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: NeumorphicContainer(
                padding: 5,
                child: TextButton(
                    onPressed: () {
                      Get.toNamed('createPlaylist');
                    },
                    child: const Text(
                      'Create New Playlist',
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            )
          ],
        );
      });
}
