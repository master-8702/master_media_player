import 'dart:io';

import 'package:flutter/material.dart';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';

import 'package:mastermediaplayer/common/models/song_model.dart';
import 'package:mastermediaplayer/features/player/presentation/audio_metadata_display.dart';

// a function to display the audio metadata of a song in a dialog
// when the user clicks on the music info button in the song playing screen.
Future<void> showAudioMetadata(BuildContext context, Song song) async {
  await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        try {
          // if the readMetadata method failed to parse the metadata, it will
          // throw an exception. In that case, we will catch the exception and
          // show an error message. If the readMetadata method is successful,
          // we will show the metadata in a dialog.
          final metadata = readMetadata(File(song.songUrl), getImage: true);
          return AlertDialog(
            title: const Text('Music Info'),
            content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AudioMetadataDisplay(metadata: metadata)),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Close'),
              ),
            ],
          );
        } catch (e) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to load music info. ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Close'),
              ),
            ],
          );
        }
      });
}
