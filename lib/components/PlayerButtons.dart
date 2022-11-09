import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'neumorphic_container.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({
    Key? key,
    required this.audioPlayer,
  }) : super(key: key);

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: NeumorphicContainer(
            child: TextButton(
              onPressed: () {
                final currentPosition = audioPlayer.position;
                audioPlayer.seek(currentPosition - const Duration(seconds: 10));
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
                  audioPlayer.hasPrevious ? audioPlayer.seekToPrevious() : null;
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
                        Text("Loading ..."),
                      ],
                    ),
                  );
                } else if (processingState == ProcessingState.buffering) {
                  return Expanded(
                    child: Column(
                      children: const [
                        CircularProgressIndicator(),
                        Text("Buffering ..."),
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
                audioPlayer.seek(currentPosition + const Duration(seconds: 10));
              },
              child: const Icon(Icons.fast_forward, size: 22),
            ),
          ),
        ),
      ],
    );
  }
}
