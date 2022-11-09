import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mastermediaplayer/components/music_seekbar_slider.dart';
import '../components/PlayerButtons.dart';
import '../components/PlaylistControlButtons.dart';
import '../components/neumorphic_container.dart';
import '../models/song_model.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class SongPlayingScreen extends StatefulWidget {
  const SongPlayingScreen({Key? key}) : super(key: key);

  @override
  State<SongPlayingScreen> createState() => _SongPlayingScreenState();
}

class _SongPlayingScreenState extends State<SongPlayingScreen> {
  late AudioPlayer audioPlayer;
  Song song = Get.arguments ?? Song.songs[0];
  late Stream<Duration> position;
  late Stream<Duration?> duration;
  late Stream<bool> shuffleMode;
  late Stream<LoopMode> loopMode;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    position = audioPlayer.positionStream;
    duration = audioPlayer.durationStream;
    shuffleMode = audioPlayer.shuffleModeEnabledStream;
    loopMode = audioPlayer.loopModeStream;

    try {
      audioPlayer.setAsset(song.songUrl);
    } catch (e) {
      print("Error loading audio source: $e");
    }
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

// here are gonna use two different streams and we will combine them
  Stream<MusicSliderPositionData> get _musicSliderDragPositionDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, MusicSliderPositionData>(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
        (Duration position, Duration? duration) =>
            MusicSliderPositionData(position, duration ?? Duration.zero),
      );

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
              mainAxisSize: MainAxisSize.min,
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
                    const Text("Now Playing"),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {},
                          child: const Icon(
                            Icons.menu_rounded,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),

                // cover art, song name , artist name, album name
                NeumorphicContainer(
                  padding: 10,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            song.coverImageUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    song.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    song.singer,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 32,
                              shadows: [
                                BoxShadow(
                                  color: Colors.red,
                                  blurRadius: 10,
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),

                // start time , shuffle button, repeat button, end time
                PlaylistControlButtons(audioPlayer: audioPlayer),
                const SizedBox(
                  height: 25,
                ),

                MusicSeekbarSlider(
                  audioPlayer: audioPlayer,
                  seekBarDataStream: _musicSliderDragPositionDataStream,
                ),

                const SizedBox(
                  height: 25,
                ),
                // previous song , ply/pause, next song buttons

                PlayerButtons(audioPlayer: audioPlayer),
                const SizedBox(
                  height: 60,
                ),
                // playing time indicator (progress bar)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
