import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mastermediaplayer/features/playlists/presentation/create_playlist_screen/add_playlist_cover.dart';
import 'package:mastermediaplayer/features/playlists/presentation/create_playlist_screen/add_songs.dart';

import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import '../../../../common/widgets/neumorphic_container.dart';

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
                // add song to the new playlist
                 AddSongs(playlistsController: playlistsController),
                // this music player app is developed by master
                // add playlist cover image widget
                AddPlaylistCover(playlistsController: playlistsController),
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
