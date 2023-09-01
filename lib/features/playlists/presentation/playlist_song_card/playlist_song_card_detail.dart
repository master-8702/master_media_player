import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_controller.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';

class PlaylistSongCardDetail extends StatelessWidget {
  const PlaylistSongCardDetail({
    super.key,
    required this.playlistPlayingScreenController,
    required this.songUrl,
    required this.indexNumber,
  });

  final PlaylistPlayingScreenController playlistPlayingScreenController;
  final String songUrl;
  final int indexNumber;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: FutureBuilder<Metadata>(
        future: Utilities.getMetadata(songUrl),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Metadata? musicMetadata = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utilities.basename(File(songUrl)),
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
                                  musicMetadata.trackDuration ?? 0000),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Obx(() {
                      if (playlistPlayingScreenController
                              .currentAudioPlayerIndex.value ==
                          (indexNumber - 1)) {
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
                  Text(songUrl),
                  const Text('Fetching Music Data ...'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
