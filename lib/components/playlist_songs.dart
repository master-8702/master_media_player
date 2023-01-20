import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';
import 'package:mastermediaplayer/controllers/favoritesController.dart';

import '../controllers/playlistsController.dart';
import '../models/playlist_model.dart';

class PlaylistSongs extends StatefulWidget {
  const PlaylistSongs({
    Key? key,
    required this.playlist,
    required this.songUrl,
    required this.indexNumber,
    required this.playingStatus,
  }) : super(key: key);

  final Playlist playlist;
  final String songUrl;
  final int indexNumber;
  final bool playingStatus;

  @override
  State<PlaylistSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  final PlaylistsController playlistsController =
      Get.put(PlaylistsController());

  final FavoritesController favoritesController =
      Get.put(FavoritesController());

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
                                if (widget.playingStatus)
                                  const Icon(Icons.play_circle),
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
                      return const [
                        PopupMenuItem(
                          value: 'Remove from Playlist',
                          child: Text('Remove from Playlist'),
                        ),
                        PopupMenuItem(
                          value: 'Add to My Favorites',
                          child: Text('Add to My Favorites'),
                        ),
                      ];
                    },
                    onSelected: (String value) async {
                      // here in the pop up menu options we will remove the selected song from the playlist
                      // or add it to the favorites list based on the user's selection

                      if (value == 'Remove from Playlist') {
                        playlistsController.removeSongFromPlaylist(
                            widget.playlist,
                            await Utilities().getSong(widget.songUrl));
                      }
                      if (value == 'Add to My Favorites') {
                        favoritesController.addFavorites(
                            await Utilities().getSong(widget.songUrl));
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
