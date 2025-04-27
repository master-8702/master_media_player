import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/routing/app_routes.dart';
import 'package:mastermediaplayer/common/models/song_model.dart';
import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';

// this function will show a dialog to add a song to a playlist
// it will show all the playlists that the user has created
// and the user can select one of them to add the song to it
// if the user has no playlists, it will show a button to create a new playlist
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
              : Obx(() {
                  return SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: playlistsController.myPlaylists.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            // here we will add the music to a playlist
                            playlistsController.addSongsToPlaylist(
                                playlistsController.myPlaylists[index],
                                [song.songUrl]);
                          },
                          trailing: const Icon(
                            Icons.add_circle,
                            size: 34,
                          ),
                          title: Text(
                              playlistsController.myPlaylists[index].title),
                          subtitle: Text(
                              '${playlistsController.myPlaylists[index].songs.length} songs'),
                        );
                      },
                    ),
                  );
                }),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: NeumorphicContainer(
                padding: 5,
                child: TextButton(
                    onPressed: () async {
                      // here the adding of [preventDuplicates: false] flag is to avoid
                      // being ignored by Getx when going to the same page multiple times from
                      // Alert Dialog or Modal Sheet.
                      // by default Getx will ignore all successive requests  made by the user after the first one,
                      // assuming it was made by mistake or the user presses the button to many times.
                      await Get.toNamed(AppRoute.createPlaylist.path,
                          preventDuplicates: false);
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
