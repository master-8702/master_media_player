import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/image_explorer_screen.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/selectable_song_explorer_screen.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';
import '../../../components/neumorphic_container.dart';

// this class will provide us with a screen(page) that will help us  in creating a new playlist
class CreatePlaylistScreen extends StatelessWidget {
  CreatePlaylistScreen({Key? key}) : super(key: key);
  final playlistsController = Get.find<PlaylistsController>();

  final TextEditingController textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Expanded(
                      child: Text(
                        "Create New Playlist",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: textEditingController,
                    validator: (value) {
                      if (value == '') {
                        return 'please insert playlist name';
                      } else {
                        // we will return null for the validator if the form is valid
                        return null;
                      }
                    },
                    decoration:
                        const InputDecoration(hintText: 'playlist name'),
                  ),
                ),
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
                                    Utilities.basename(File(playlistsController
                                        .selectedSongs[index])),
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
                // this music player app is developed by master
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
                const SizedBox(
                  height: 15,
                ),
                NeumorphicContainer(
                  child: TextButton(
                    onPressed: () async {
                      // this will validate the form (actually the single field D:) on the clicking of the Save button.
                      final isTheFormValid = formKey.currentState!.validate();
                      if (isTheFormValid) {
                        if (playlistsController.selectedSongs.isEmpty) {
                          Get.snackbar('Warning',
                              'You have to select at least one song ');
                        } else {
                          // here if the user selects an image we will copy that image to the application document directory
                          // otherwise if we take the original path and the file gets deleted , the app will break (in the image widgets)
                          playlistsController.createPlaylist(
                              title: textEditingController.text);
                          Get.back();
                        }
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
