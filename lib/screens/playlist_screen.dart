import 'package:flutter/material.dart';
import 'package:mastermediaplayer/models/playlist_model.dart';
import '../components/neumorphic_container.dart';
import '../components/play_or_shuffle_switch.dart';
import '../components/playlist_card_main.dart';
import '../components/playlist_songs.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    Playlist myPlaylist = Playlist.myPlaylists[0];

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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            myPlaylist.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {},
                          child: const Icon(Icons.menu_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                PlaylistCardMain(myPlaylist: myPlaylist),
                const SizedBox(
                  height: 25,
                ),
                const PlayOrShuffleSwitch(),
                const SizedBox(
                  height: 15,
                ),
                PlaylistSongs(myPlaylist: myPlaylist)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
