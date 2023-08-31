import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_controller.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favoritesController.dart';

import '../features/playlists/domain/playlist.dart';

class PlaylistSongs extends StatefulWidget {
  const PlaylistSongs({
    Key? key,
    required this.playlist,
    required this.songUrl,
    required this.indexNumber,
  }) : super(key: key);

  final Playlist playlist;
  final String songUrl;
  final int indexNumber;

  @override
  State<PlaylistSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  final playlistsController = Get.find<PlaylistsController>();
  final singlePlaylistScreenController =
      Get.find<PlaylistPlayingScreenController>();

  final favoritesController = Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NeumorphicContainer(
          padding: 5,
          // margin: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${widget.indexNumber}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: FutureBuilder<Metadata>(
                    future: Utilities.getMetadata(widget.songUrl),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Metadata? musicMetadata = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utilities.basename(File(widget.songUrl)),
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    musicMetadata!.albumName ?? 'Unknown album',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    Utilities.formatDuration(
                                      Duration(
                                          milliseconds:
                                              musicMetadata.trackDuration ??
                                                  0000),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Obx(() {
                                  if (singlePlaylistScreenController
                                          .currentAudioPlayerIndex.value ==
                                      (widget.indexNumber - 1)) {
                                    return const Icon(Icons.play_circle);
                                  } else {
                                    return const SizedBox();
                                  }
                                }),
                              ],
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error Happened while Fetching Data!'),
                        );
                      } else {
                        return Center(
                          child: Column(
                            children: [
                              const CircularProgressIndicator(),
                              Text(widget.songUrl),
                              const Text('Fetching Music Data ...'),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
                PopupMenuButton(
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        if (singlePlaylistScreenController
                                .currentAudioPlayerIndex.value !=
                            (widget.indexNumber - 1))
                          const PopupMenuItem(
                            value: 'Remove from Playlist',
                            child: Text('Remove from Playlist'),
                          ),
                        const PopupMenuItem(
                          value: 'Add to My Favorites',
                          child: Text('Add to My Favorites'),
                        ),
                      ];
                    },
                    onSelected: (String value) async {
                      // here in the pop up menu options we will remove the selected song from the playlist
                      // or add it to the favorites list based on the user's selection

                      if (value == 'Remove from Playlist') {
                        playlistsController.addOrRemoveSongsFromPlaylist(
                            widget.playlist, [widget.songUrl]);
                      }
                      if (value == 'Add to My Favorites') {
                        // favoritesController.addFavorites(
                        //     await Utilities().getSong(widget.songUrl));
                      }
                    }),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
