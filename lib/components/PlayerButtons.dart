import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../controllers/playlistsController.dart';
import 'neumorphic_container.dart';

class PlayerButtons extends StatelessWidget {
  PlayerButtons({
    Key? key,
    required this.audioPlayer,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final PlaylistsController playlistsController =
      Get.put(PlaylistsController());

  @override
  Widget build(BuildContext context) {
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
                  audioPlayer
                      .seek(currentPosition - const Duration(seconds: 10));
                },
                child: const Icon(Icons.fast_rewind, size: 22),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          StreamBuilder<SequenceState>(builder: (context, index) {
            return Expanded(
              flex: 2,
              child: NeumorphicContainer(
                child: TextButton(
                  onPressed: () {
                    // this will rebuild the ui in order to add the play icon on currently playing music list
                    playlistsController
                        .justRebuildTheUi(audioPlayer.previousIndex!);
// this will set the audio player to play the previous song in the playlist if there is any
                    audioPlayer.hasPrevious
                        ? audioPlayer.seekToPrevious()
                        : null;
                  },
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
                    return Expanded(
                      child: Column(
                        children: const [
                          CircularProgressIndicator(),
                          Text(
                            "Loading ...",
                            style: TextStyle(fontSize: 6),
                          ),
                        ],
                      ),
                    );
                  } else if (processingState == ProcessingState.buffering) {
                    return Expanded(
                      child: Column(
                        children: const [
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
          StreamBuilder<SequenceState>(builder: (context, index) {
            return Expanded(
              flex: 2,
              child: NeumorphicContainer(
                child: TextButton(
                  onPressed: () {
                    // this will rebuild the ui in order to add the play icon on currently playing music list
                    playlistsController
                        .justRebuildTheUi(audioPlayer.nextIndex!);
                    // this will set the audio player to play the next song in the playlist if there is any

                    audioPlayer.hasNext ? audioPlayer.seekToNext() : null;
                  },
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
