import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/components/section_header.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';
import 'package:mastermediaplayer/controllers/favoritesController.dart';
import 'package:mastermediaplayer/controllers/playlistsController.dart';
import '../components/my_favorites.dart';
import '../components/playlists_search_bar.dart';
import '../components/playlist_card.dart';
import '../models/playlist_model.dart';

// this class will be our landing screen (home page) for our app
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
    // here we will request storage permission in case it was not allowed during installation
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

                    Expanded(
                      child: Center(
                        child: Text("Master Player",
                            style: Theme.of(context).textTheme.headlineSmall),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () async {
                            Get.toNamed('settings');
                          },
                          child: const Icon(
                            Icons.settings,
                          ),
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
                    return Column(
                      children: [
                        InkWell(
                            onTap: () {
                              Get.toNamed('favorites');
                            },
                            child: const SectionHeader(title: 'Favorites')),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text('No Favorites yet!'),
                      ],
                    );
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
                        return Column(
                          children: const [
                            SizedBox(
                              height: 15,
                            ),
                            Text('No Playlists yet!'),
                          ],
                        );
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 20),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: playlistState.myPlaylists.length <= 5
                                ? playlistState.myPlaylists.length
                                : 5,
                            itemBuilder: (context, index) {
                              return PlaylistCard(
                                  myPlaylist: playlistState.myPlaylists[index]);
                            });
                      }
                    }),
                    // this music player app is developed by master
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: NeumorphicContainer(
                        padding: 5,
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
                    ),
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
