import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:mastermediaplayer/common/models/song_model.dart';

// TODO: change the song model proper location
// TODO: create a new model for the metadata and manipulate it as we want
//  rather than just calling toString();

Future<void> getMusicInfo(BuildContext context, Song song) async {
  await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Music Info'),
          content: FutureBuilder<Metadata>(
            future: MetadataRetriever.fromFile(File(song.songUrl)),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Metadata musicInfo = snapshot.data as Metadata;

                List<String> musicInfo2 = musicInfo
                    .toString()
                    .replaceAll('null', 'NA')
                    .split(',')
                    .toList();

                return SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                      // shrinkWrap: true,
                      itemCount: musicInfo2.length,
                      itemBuilder: (context, index) {
                        return ListTile(title: Text(musicInfo2[index]));
                      }),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error Occurred! Can not load music info.'),
                );
              } else {
                return const Center(
                  child: Text('Something Happened!'),
                );
              }
            },
          ),
        );
      });
}
