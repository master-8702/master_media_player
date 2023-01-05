import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/neumorphic_container.dart';
import '../components/playlist_card.dart';
import '../controllers/playlistsController.dart';

class PlaylistsScreen extends StatelessWidget {
  PlaylistsScreen({Key? key}) : super(key: key);
  final PlaylistsController playlistsController =
      Get.put(PlaylistsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('My Playlists'),
        leading: SizedBox(
          height: 60,
          width: 20,
          child: NeumorphicContainer(
            margin: 5,
            child: TextButton(
              onPressed: () {},
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GetBuilder<PlaylistsController>(builder: (playlistState) {
            if (playlistState.myPlaylists.isEmpty) {
              return Flexible(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No Playlists Yet!'),
                      const SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed('createPlaylist');
                        },
                        child: const Text('Create New Playlist'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Column(children: [
              Flexible(
                child: ListView.builder(
                    clipBehavior: Clip.none,
                    itemCount: playlistState.myPlaylists.length,
                    itemBuilder: (context, index) {
                      return PlaylistCard(
                          myPlaylist: playlistState.myPlaylists[index]);
                    }),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('createPlaylist');
                },
                child: const Text('Create New Playlist'),
              )
            ]);
          }),
        ),
      ),
    );
  }
}
