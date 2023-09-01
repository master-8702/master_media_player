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
      songs: List<String>.from(map['songs']),
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
