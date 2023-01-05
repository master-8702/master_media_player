import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mastermediaplayer/components/utilities/utilities.dart';
import 'package:mastermediaplayer/models/playlist_model.dart';
import 'package:text_scroll/text_scroll.dart';
import '../components/PlayerButtons.dart';
import '../components/PlaylistControlButtons.dart';
import '../components/music_seekbar_slider.dart';
import '../components/neumorphic_container.dart';
import '../components/playlist_card_main.dart';
import '../components/playlist_songs.dart';
import '../controllers/playlistsController.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class SinglePlaylistScreen extends StatefulWidget {
  const SinglePlaylistScreen({Key? key}) : super(key: key);

  @override
  State<SinglePlaylistScreen> createState() => _SinglePlaylistScreenState();
}

class _SinglePlaylistScreenState extends State<SinglePlaylistScreen> {
  Playlist myPlaylist = Get.arguments;
  AudioPlayer audioPlayer = AudioPlayer();
  late var selectedSongs = <String>[].obs;

  final PlaylistsController playlistsController =
      Get.put(PlaylistsController());

  @override
  void initState() {
    // here we will initialize the index to zero cause the last playlist's index might not be found on the new one
    // so we will avoid range error (index out of range error)
    playlistsController.currentAudioPlayerIndex.value = 0;
    // here we will concatenate audio sources to the player from the playlist song's file
    List<AudioSource> audioSources = [];
    for (String songPath in myPlaylist.songs) {
      audioSources.add(AudioSource.uri(Uri.file(songPath)));
    }
    final playlist = ConcatenatingAudioSource(
        children: audioSources,
        shuffleOrder: DefaultShuffleOrder(),
        useLazyPreparation: true);
    audioPlayer.setAudioSource(
      playlist,
    );

    super.initState();
  }

  // here we are gonna use two different streams and we will combine them using rxdart package
  Stream<MusicSliderPositionData> get _musicSliderDragPositionDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, MusicSliderPositionData>(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
        (Duration position, Duration? duration) =>
            MusicSliderPositionData(position, duration ?? Duration.zero),
      );

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    audioPlayer.play();
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
                          onPressed: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 30,
                            color: Colors.black,
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
                        child: PopupMenuButton(
                          onSelected: (selectedValue) async {
                            if (selectedValue == 'add music to this Playlist') {
                              selectedSongs =
                                  await Get.toNamed('songExplorer2');
                              playlistsController.addMusicToPlaylist(
                                  myPlaylist, selectedSongs);
                            }
                          },
                          itemBuilder: (context) {
                            return const [
                              PopupMenuItem(
                                value: 'add music to this Playlist',
                                child: Text('add music to this Playlist'),
                              )
                            ];
                          },
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
                  height: 15,
                ),
                Obx(
                  () => NeumorphicContainer(
                    padding: 10,
                    child: Column(
                      children: [
                        const Text('Now Playing:'),
                        TextScroll(
                          Utilities.basename(
                            File(myPlaylist.songs[playlistsController
                                .currentAudioPlayerIndex.value]),
                          ),
                          style: const TextStyle(fontSize: 22),
                          velocity:
                              const Velocity(pixelsPerSecond: Offset(30, 30)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PlaylistControlButtons(audioPlayer: audioPlayer),
                    const SizedBox(
                      height: 15,
                    ),
                    MusicSeekbarSlider(
                      audioPlayer: audioPlayer,
                      seekBarDataStream: _musicSliderDragPositionDataStream,
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    // previous song , ply/pause, next song buttons

                    PlayerButtons(audioPlayer: audioPlayer),
                  ],
                ),
                const Divider(),
                const SizedBox(
                  height: 15,
                ),
                GetBuilder<PlaylistsController>(builder: (context) {
                  return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      clipBehavior: Clip.none,
                      itemCount: myPlaylist.songs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            audioPlayer.seek(Duration.zero, index: index);
                            playlistsController.justRebuildTheUi(index);
                          },
                          child: PlaylistSongs(
                              playingStatus: playlistsController
                                      .currentAudioPlayerIndex.value ==
                                  index,
                              playlist: myPlaylist,
                              indexNumber: index + 1,
                              songUrl: myPlaylist.songs[index]),
                        );
                      });
                  //
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
