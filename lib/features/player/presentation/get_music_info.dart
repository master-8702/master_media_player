import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:mastermediaplayer/models/song_model.dart';

// TODO: change the song model proper location
Future<void> getMusicInfo(BuildContext context, Song song) async{
    await  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Music Info'),
                          content: FutureBuilder<Metadata>(
                            future: MetadataRetriever.fromFile(
                                File(song.songUrl)),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                Metadata musicInfo =
                                    snapshot.data as Metadata;
                                List<String> musicInfo2 =
                                    musicInfo
                                        .toString()
                                        .replaceAll('null', 'NA')
                                        .split(',')
                                        .toList();
                                return ListView.builder(
                                    itemCount: musicInfo2.length,
                                    itemBuilder:
                                        (context, index) {
                                      return ListTile(
                                          title: Text(
                                              musicInfo2[index]));
                                    });
                              } else if (snapshot.hasError) {
                                return const Center(
                                  child: Text(
                                      'Error Occurred! Can not load music info.'),
                                );
                              } else {
                                return const Center(
                                  child:
                                      Text('Something Happened!'),
                                );
                              }
                            },
                          ),
                        );
                      });
  }