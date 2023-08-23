// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Playlist {
  final String title;
  List<String> songs;
  final String coverImageUrl;

  Playlist({
    required this.title,
    required this.songs,
    required this.coverImageUrl,
  });

  // set setSong(List<String> songs) {
  //   this.songs = songs;
  // }

  // //stored String to object
  // Playlist.fromString(String string) {
  //   var decode = jsonDecode(string);
  //   Map<String, dynamic> playlistMap = decode;
  //   // Playlist playlist = Playlist.fromString(string);
  //   String temp = playlistMap['songs'];
  //   List<String> songs = temp.split('~`');

  //   title = playlistMap['title'];
  //   this.songs = songs;
  //   coverImageUrl = playlistMap['coverImage'];
  // }

  // // here we will override the 'toString' method of object class
  // // in order to customize it for our purpose
  // @override
  // String toString() {
  //   String songUrls = '';
  //   for (String songUrlTemp in songs) {
  //     if (songs.indexOf(songUrlTemp) != 0) {
  //       songUrls += '~`';
  //     }
  //     songUrls += (songUrlTemp);
  //   }
  //   songUrls = songUrls.replaceAll('"', '\\"');

  //   String objectAsString =
  //       '{"title":"$title", "songs":"$songUrls", "coverImage":"$coverImageUrl"}';

  //   return objectAsString;
  // }


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'songs': songs,
      'coverImageUrl': coverImageUrl,
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      title: map['title'] as String,
      songs: List<String>.from((map['songs'] as List<String>)),
      coverImageUrl: map['coverImageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Playlist.fromJson(String source) =>
      Playlist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Playlist(title: $title, songs: $songs, coverImageUrl: $coverImageUrl)';

  @override
  bool operator ==(covariant Playlist other) {
    if (identical(this, other)) return true;

    return other.title == title && listEquals(other.songs, songs); // &&
    // other.coverImageUrl == coverImageUrl;
  }

  @override
  int get hashCode => title.hashCode ^ songs.hashCode ^ coverImageUrl.hashCode;
}
