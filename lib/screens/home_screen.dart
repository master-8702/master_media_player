import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/components/section_header.dart';
import 'package:mastermediaplayer/components/utilities/utilities.dart';
import 'package:mastermediaplayer/controllers/favoritesController.dart';
import 'package:mastermediaplayer/controllers/playlistsController.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/my_favorites.dart';
import '../components/music_search_bar.dart';
import '../components/playlist_card.dart';
import '../models/playlist_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FavoritesController favoritesController =
      Get.put(FavoritesController());
  final PlaylistsController playlistsController =
      Get.put(PlaylistsController());
  late List<Playlist> myPlaylist;

  @override
  void initState() {
    Utilities().requestPermission();
    // GetStorage().remove('myPlaylist');
    favoritesController.getFavoriteMusics();
    playlistsController.getPlaylists();
    myPlaylist = playlistsController.myPlaylists;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // menu and back button
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {},
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Master Player",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () async {
                            Utilities().requestPermission();

                            Get.toNamed('explorer');
                          },
                          child: const Icon(Icons.folder),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                const MusicSearchBar(),
                const SizedBox(
                  height: 25,
                ),
                GetBuilder<FavoritesController>(builder: (state) {
                  if (state.myFavoriteSongs.isEmpty) {
                    return const Text('No Favorites yet!');
                  }
                  return MyFavorites(myFavoriteSongs: state.myFavoriteSongs);
                }),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                        onTap: () {
                          Get.toNamed('playlists');
                        },
                        child: const SectionHeader(title: "Playlists")),
                    GetBuilder<PlaylistsController>(builder: (playlistState) {
                      if (playlistsController.myPlaylists.isEmpty) {
                        return const Text('No Playlists yet!');
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 20),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: playlistState.myPlaylists.length,
                            itemBuilder: (context, index) {
                              return PlaylistCard(
                                  myPlaylist: playlistState.myPlaylists[index]);
                            });
                      }
                    }),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed('createPlaylist');
                        },
                        child: const Text('Create New Playlist'),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
