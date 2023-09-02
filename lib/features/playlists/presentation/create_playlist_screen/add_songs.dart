import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/features/file_explorer/presentation/selectable_song_explorer_screen.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/utilities/file_and_directory_utilities.dart';

class AddSongs extends StatelessWidget {
  const AddSongs({super.key, required this.playlistsController});

  final PlaylistsController playlistsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            playlistsController.selectedSongs.value =
                await Get.to(const SelectableSongExplorerScreen());
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Add Musics'),
              Icon(Icons.music_note),
            ],
          ),
        ),
        Obx(
          () => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: playlistsController.selectedSongs.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Text('${index + 1} '),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            FileAndDirectoryUtilities.basename(
                                File(playlistsController.selectedSongs[index])),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }
}
