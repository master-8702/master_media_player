import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/neumorphic_container.dart';
import '../components/playlist_card.dart';
import '../controllers/playlistsController.dart';

// this class will build the UI for the playlists page to show us all the available Playlists
// in our local storage
class PlaylistsScreen extends StatelessWidget {
  PlaylistsScreen({Key? key}) : super(key: key);
  final PlaylistsController playlistsController =
      Get.put(PlaylistsController());
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                    width: 50,
                  ),
                  const Expanded(
                    child: Text(
                      "My Playlists",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              GetBuilder<PlaylistsController>(builder: (playlistState) {
                if (playlistState.myPlaylists.isEmpty) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No Playlists Yet!'),
                        const SizedBox(
                          height: 25,
                        ),
                        NeumorphicContainer(
                          child: TextButton(
                            onPressed: () {
                              Get.toNamed('createPlaylist');
                            },
                            child: const Text(
                              'Create New Playlist',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        // this music player app is developed by master
                      ],
                    ),
                  );
                }
                return Expanded(
                  child: Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                            shrinkWrap: true,
                            clipBehavior: Clip.antiAlias,
                            itemCount: playlistState.myPlaylists.length,
                            itemBuilder: (context, index) {
                              return PlaylistCard(
                                  myPlaylist: playlistState.myPlaylists[index]);
                            }),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed('createPlaylist');
                          },
                          child: const Text(
                            'Create New Playlist',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
