import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/features/file_explorer/presentation/image_explorer_screen.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';

class AddPlaylistCover extends StatelessWidget {
  const AddPlaylistCover({
    super.key,
    required this.playlistsController,
  });

  final PlaylistsController playlistsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            playlistsController.selectedCoverImage.value =
                await Get.to(ImageExplorerScreen());
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Add playlist Cover'),
              Icon(Icons.image),
            ],
          ),
        ),
        Obx(
          () => SizedBox(
            width: 200,
            height: 200,
            child: playlistsController.selectedCoverImage.isEmpty
                ? const Icon(Icons.image, size: 200)
                : Image.file(
                    File(playlistsController.selectedCoverImage.value)),
          ),
        ),
      ],
    );
  }
}
