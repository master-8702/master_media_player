import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_card.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/routing/app_routes.dart';

// this class will build the UI for the playlists page to show us all the saved Playlists
// from our local storage
class PlaylistsScreen extends StatelessWidget {
  PlaylistsScreen({Key? key}) : super(key: key);
  final playlistsController = Get.find<PlaylistsController>();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Expanded(
                    child: Text("My Playlists",
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Obx(() {
                if (playlistsController.myPlaylists.isEmpty) {
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
                              Get.toNamed(AppRoute.createPlaylist.path);
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
                            itemCount: playlistsController.myPlaylists.length,
                            itemBuilder: (context, index) {
                              return PlaylistCard(
                                  myPlaylist:
                                      playlistsController.myPlaylists[index]);
                            }),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoute.createPlaylist.path);
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
