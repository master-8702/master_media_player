import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mastermediaplayer/components/utilities/utilities.dart';

class PlaylistControlButtons extends StatefulWidget {
  const PlaylistControlButtons({Key? key, required this.audioPlayer})
      : super(key: key);
  final AudioPlayer audioPlayer;

  @override
  State<PlaylistControlButtons> createState() => _PlaylistControlButtonsState();
}

class _PlaylistControlButtonsState extends State<PlaylistControlButtons> {
  late Stream<Duration> position;
  late Stream<Duration?> duration;
  late Stream<bool> shuffleMode;
  late Stream<LoopMode> loopMode;

  @override
  initState() {
    position = widget.audioPlayer.positionStream;
    duration = widget.audioPlayer.durationStream;
    shuffleMode = widget.audioPlayer.shuffleModeEnabledStream;
    loopMode = widget.audioPlayer.loopModeStream;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 50,
          width: 40,
          child: StreamBuilder(
              initialData: Duration.zero,
              stream: position,
              builder: (context, snapshot) {
                return Text(
                    Utilities.formatDuration(snapshot.data as Duration));
              }),
        ),
        SizedBox(
          height: 50,
          width: 40,
          child: StreamBuilder<bool>(
            stream: shuffleMode,
            builder: (context, snapshot) {
              return _shuffleButton(context, snapshot.data ?? false);
            },
          ),
        ),
        SizedBox(
          height: 50,
          width: 40,
          child: StreamBuilder<LoopMode>(
            stream: loopMode,
            builder: (context, snapshot) {
              return _repeatButton(context, snapshot.data ?? LoopMode.off);
            },
          ),
        ),
        SizedBox(
          height: 50,
          width: 40,
          child: StreamBuilder(
              initialData: Duration.zero,
              stream: duration,
              builder: (context, snapshot) {
                return Text(
                    Utilities.formatDuration(snapshot.data as Duration));
              }),
        ),
      ],
    );
  }

  Widget _shuffleButton(BuildContext context, bool isEnabled) {
    return IconButton(
      icon: isEnabled
          ? Icon(Icons.shuffle, color: Theme.of(context).colorScheme.secondary)
          : const Icon(Icons.shuffle),
      onPressed: () async {
        final enable = !isEnabled;
        if (enable) {
          await widget.audioPlayer.shuffle();
        }
        await widget.audioPlayer.setShuffleModeEnabled(enable);
      },
    );
  }

  Widget _repeatButton(BuildContext context, LoopMode loopMode) {
    final icons = [
      const Icon(Icons.repeat),
      Icon(Icons.repeat, color: Theme.of(context).colorScheme.secondary),
      Icon(Icons.repeat_one, color: Theme.of(context).colorScheme.secondary),
    ];
    const cycleModes = [
      LoopMode.off,
      LoopMode.all,
      LoopMode.one,
    ];
    final index = cycleModes.indexOf(loopMode);
    return IconButton(
      icon: icons[index],
      onPressed: () {
        widget.audioPlayer.setLoopMode(
            cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
      },
    );
  }
}

class MusicSliderPositionData {
  final Duration position; // how much of the song is already played
  final Duration duration; // how ong is the song

  MusicSliderPositionData(this.position, this.duration);
}
