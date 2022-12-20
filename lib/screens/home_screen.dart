import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/components/section_header.dart';
import 'package:mastermediaplayer/controllers/favoritesController.dart';
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
  List<Playlist> myPlaylist = Playlist.myPlaylists;

  final FavoritesController favoritesController =
      Get.put(FavoritesController());

  @override
  void initState() {
    favoritesController.getFavoriteMusics();
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
                          onPressed: () {
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
                    return Text('No Favorites yet!');
                  }
                  return MyFavorites(myFavoriteSongs: state.myFavoriteSongs);
                }),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    const SectionHeader(title: "Playlists"),
                    ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 20),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: myPlaylist.length,
                        itemBuilder: (context, index) {
                          return PlaylistCard(myPlaylist: myPlaylist[index]);
                        }),
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
