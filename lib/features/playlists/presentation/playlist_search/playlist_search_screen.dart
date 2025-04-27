import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_card.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_search/no_search_result.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_search/playlist_search_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_search/playlist_search_result_list.dart';

/// FEATURE UNDER PROGRESS
class PlaylistSearchScreen extends StatelessWidget {
  PlaylistSearchScreen({Key? key}) : super(key: key);

  // final playlistsController = Get.find<PlaylistsController>();
  final TextEditingController textEditingController = TextEditingController();
  final playlistsController = Get.find<PlaylistsController>();
  final playlistSearchController = Get.put(PlaylistSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: NeumorphicContainer(
                        padding: 5,
                        child: TextField(
                          autofocus: true,
                          controller: textEditingController,
                          decoration: InputDecoration(
                              hintText: 'search your playlists',
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    if (textEditingController.text.isEmpty) {
                                    } else {
                                      playlistSearchController.playlistSearcher(
                                          textEditingController.text);
                                    }
                                  },
                                  icon: const Icon(Icons.search))),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                // and here in this Obx(Observable widget from GetX) we will display the search result
                // or a little funny 'no result found' message
                child: Obx(() {
                  if (textEditingController.text.isNotEmpty &&
                      playlistSearchController.foundSongs.isEmpty &&
                      playlistSearchController.foundPlaylist.isEmpty) {
                    // no search result widget with a funny emoji
                    return const NoSearchResult();
                  } else if (playlistSearchController.foundSongs.isNotEmpty) {
                    // here by using the builder constructor of ListView we will normally display the search results that are only
                    // music related (foundSongs) and when the the builder is at the last iteration then we will add the 'playlist related'
                    // search results (foundPlaylist)s to the end of the existing list (in the column) after adding the last item from foundSongs

                    return PlaylistSearchResultList(
                        playlistSearchController: playlistSearchController,
                        playlistsController: playlistsController);
                  } else {
                    // here 'else' means when foundSongs is empty we don't need to append the foundPlaylist to the foundSongs
                    // so we will just display it as a normal independent list with it's own scrolling function and lazyLoad behavior
                    return ListView(
                      children: playlistSearchController.foundPlaylist
                          .map((element) => PlaylistCard(myPlaylist: element))
                          .toList(),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
