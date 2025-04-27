import 'dart:math';

import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';

import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';
import 'package:mastermediaplayer/features/player/domain/music_slider_position_data.dart';

class MusicSeekBarSlider extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final Stream<MusicSliderPositionData> seekBarDataStream;

  const MusicSeekBarSlider(
      {Key? key, required this.audioPlayer, required this.seekBarDataStream})
      : super(key: key);

  @override
  State<MusicSeekBarSlider> createState() => _MusicSeekBarSliderState();
}

class _MusicSeekBarSliderState extends State<MusicSeekBarSlider> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: StreamBuilder<MusicSliderPositionData>(
          initialData: MusicSliderPositionData(Duration.zero, Duration.zero),
          stream: widget.seekBarDataStream,
          builder: (context, snapshot) {
            final newData = snapshot.data;
            return SliderTheme(
              data: SliderThemeData(
                trackHeight: 8,
                inactiveTrackColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: NeumorphicContainer(
                child: Slider(
                    min: 0.0,
                    max: newData!.duration.inMilliseconds.toDouble(),
                    value: min(
                      _dragValue ?? newData.position.inMilliseconds.toDouble(),
                      newData.duration.inMilliseconds.toDouble(),
                    ),
                    onChanged: (newPosition) {
                      setState(() {
                        _dragValue = newPosition;
                      });

                      widget.audioPlayer
                          .seek(Duration(milliseconds: newPosition.round()));
                      _dragValue = null;
                    }),
              ),
            );
          }),
    );
  }
}
