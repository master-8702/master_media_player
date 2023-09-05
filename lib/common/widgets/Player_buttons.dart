import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_controller.dart';

import 'neumorphic_container.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({
    Key? key,
    required this.audioPlayer,
    // required this.playlistsController,
    this.playlistPlayingScreenController,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final PlaylistPlayingScreenController? playlistPlayingScreenController;

  @override
  Widget build(BuildContext context) {
    // here we are listening the sequenceStream of the audioPlayer to detect the changes
    // in the number of songs(audio sources). so that if there are more than one song it means
    // we are playing a playlist and we need to enable playlist related buttons like, next, previous
    // shuffle.
    Rx<bool> isPlaylist = false.obs;
    audioPlayer.sequenceStream.listen((event) {
      if (event != null) {
        if (event.length > 1) {
          isPlaylist.value = true;
        } else {
          isPlaylist.value = false;
        }
      }
    });

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: NeumorphicContainer(
              child: TextButton(
                onPressed: () {
                  final currentPosition = audioPlayer.position;
                  if ((currentPosition - const Duration(seconds: 10)) >
                      Duration.zero) {
                    audioPlayer
                        .seek(currentPosition - const Duration(seconds: 10));
                  } else {
                    audioPlayer.seek(Duration.zero);
                  }
                },
                child: const Icon(Icons.fast_rewind, size: 22),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Obx(() {
            return Expanded(
              flex: 2,
              child: NeumorphicContainer(
                child: TextButton(
                  onPressed: isPlaylist.value
                      ? () async {
                          // this will set the audio player to play the previous song in the playlist if there is any
                          audioPlayer.hasPrevious
                              ? await audioPlayer.seekToPrevious()
                              : null;
                          playlistPlayingScreenController!
                              .currentAudioPlayerIndex
                              .value = audioPlayer.currentIndex ?? 0;
                        }
                      : null,
                  child: const Icon(Icons.skip_previous, size: 22),
                ),
              ),
            );
          }),
          const SizedBox(
            width: 10,
          ),
          StreamBuilder<PlayerState>(
              stream: audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final playerState = snapshot.data;
                  // we need to cast it to PlayerState object
                  final processingState = playerState!.processingState;
                  if (processingState == ProcessingState.loading) {
                    return const Expanded(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          Text(
                            "Loading ...",
                            style: TextStyle(fontSize: 6),
                          ),
                        ],
                      ),
                    );
                  } else if (processingState == ProcessingState.buffering) {
                    return const Expanded(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          Text(
                            "Buffering ...",
                            style: TextStyle(fontSize: 6),
                          ),
                        ],
                      ),
                    );
                  } else if (!audioPlayer.playing) {
                    return Expanded(
                      flex: 3,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {
                            audioPlayer.play();
                          },
                          child: const Icon(
                            Icons.play_arrow,
                            size: 45,
                          ),
                        ),
                      ),
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return Expanded(
                      flex: 3,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {
                            audioPlayer.pause();
                          },
                          child: const Icon(
                            Icons.pause,
                            size: 45,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      flex: 3,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {
                            audioPlayer.seek(Duration.zero,
                                index: audioPlayer.effectiveIndices!.first);
                          },
                          child: const Icon(
                            Icons.replay,
                            size: 45,
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return const Expanded(child: CircularProgressIndicator());
                }
              }),
          const SizedBox(
            width: 10,
          ),
          Obx(() {
            return Expanded(
              flex: 2,
              child: NeumorphicContainer(
                child: TextButton(
                  // here we are assigning onPressed a callback or a null value depending on the
                  // number of songs available in the audioSources of the audioPlayer. if there is only
                  // one song(not a playlist) we will disable the next button since there are no any songs to
                  // next by returning null. (note: if a buttons callback is null the button will be disabled).
                  onPressed: isPlaylist.value
                      ? () async {
                          // this will set the audio player to play the next song in the playlist if there is any
                          audioPlayer.hasNext
                              ? await audioPlayer.seekToNext()
                              : null;
                          playlistPlayingScreenController!
                              .currentAudioPlayerIndex
                              .value = audioPlayer.currentIndex ?? 0;
                        }
                      : null,
                  child: const Icon(Icons.skip_next, size: 22),
                ),
              ),
            );
          }),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 2,
            child: NeumorphicContainer(
              child: TextButton(
                onPressed: () {
                  final currentPosition = audioPlayer.position;
                  audioPlayer
                      .seek(currentPosition + const Duration(seconds: 10));
                },
                child: const Icon(Icons.fast_forward, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
