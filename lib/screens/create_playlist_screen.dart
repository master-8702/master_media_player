import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/components/utilities/utilities.dart';
import 'package:mastermediaplayer/models/playlist_model.dart';
import 'package:mastermediaplayer/screens/music_explorer_screen3.dart';
import 'package:path_provider/path_provider.dart';
import '../controllers/playlistsController.dart';
import 'music_explorer_screen2.dart';

class CreatePlaylistScreen extends StatelessWidget {
  CreatePlaylistScreen({Key? key}) : super(key: key);
  final PlaylistsController playlistsController =
      Get.put(PlaylistsController());
  final selectedCoverImage = ''.obs;
  final selectedSongs = <String>[].obs;
  final TextEditingController textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<String> myList = [];
    for (int i = 0; i < 32; i++) {
      myList.add('My age is $i');
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Playlist'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                    selectedSongs.value = await Get.to(const MusicExplorer2());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Add Musics'),
                      Icon(Icons.music_note),
                    ],
                  ),
                ),
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: selectedSongs.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Text('${index + 1} '),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Card(
                                child: Text(
                                  Utilities.basename(
                                      File(selectedSongs[index])),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
                TextButton(
                  onPressed: () async {
                    selectedCoverImage.value =
                        await Get.to(const MusicExplorer3());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Add playlist Cover'),
                      Icon(Icons.image),
                    ],
                  ),
                ),
                Obx(
                  () => SizedBox(
                    width: 200,
                    height: 200,
                    child: selectedCoverImage.isEmpty
                        ? const Icon(Icons.image, size: 200)
                        : Image.file(File(selectedCoverImage.value)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    //this will hold the new image path in the application document directory
                    var newImagePath = File('');
                    // this will validate the form (actually the single field D:) on the clicking of the Save button.
                    final isTheFormValid = formKey.currentState!.validate();
                    if (isTheFormValid) {
                      if (selectedSongs.isEmpty) {
                        Get.snackbar(
                            'Warning', 'You have to select at least one song ');
                      } else {
                        // here if the user selects an image we will copy that image to the application document directory
                        // otherwise if we take the original path and the file gets deleted , the app will break (in the image widgets)
                        Directory applicationDirectory =
                            await getApplicationDocumentsDirectory();
                        if (selectedCoverImage.value != '') {
                          final File coverImage =
                              File(selectedCoverImage.value);
                          String fileNameWithExtension =
                              coverImage.path.split('/').last;
                          newImagePath = await coverImage.copy(
                              '${applicationDirectory.path}/$fileNameWithExtension');
                        }
// if everything is so far so good we will create a new playlist and save that data permanently
// by calling addNewPlaylist from playlistController

                        Playlist playlist = Playlist(
                            title: textEditingController.text,
                            songs: selectedSongs,
                            coverImageUrl: selectedCoverImage.value == ''
                                ? 'assets/images/playlist.png'
                                : newImagePath.path);
                        playlistsController.addNewPlaylist(playlist);
                        Get.back();
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}