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
            // opening the file explorer and receiving selected images when closed
            String? selectedCoverImage =
                await Get.to(() => const ImageExplorerScreen());

            if (selectedCoverImage != null) {
              // assigning the selected image to the selectedCoverImage in the
              // controller if they are selected and not empty
              playlistsController.selectedCoverImage.value = selectedCoverImage;
            }
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
        // this button will clear the selected cover image
        Obx(
          () => playlistsController.selectedCoverImage.isEmpty
              ? const SizedBox()
              : TextButton(
                  onPressed: () {
                    playlistsController.selectedCoverImage.value = '';
                  },
                  child: const Text('Clear Cover Image'),
                ),
        ),
      ],
    );
  }
}
