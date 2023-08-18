// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

class Song {
  final String title;
  final String? artist;
  final String? albumTitle;
  final String songUrl;
  final Uint8List? coverImageUrl;

  Song({
    required this.title,
    this.artist,
    this.albumTitle,
    required this.songUrl,
    this.coverImageUrl,
  });

  Song copyWith({
    String? title,
    String? artist,
    String? albumTitle,
    String? songUrl,
    Uint8List? coverImageUrl,
  }) {
    return Song(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      albumTitle: albumTitle ?? this.albumTitle,
      songUrl: songUrl ?? this.songUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'artist': artist,
      'albumTitle': albumTitle,
      'songUrl': songUrl,
      'coverImageUrl': coverImageUrl?.toString(),
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      title: map['title'] as String,
      artist: map['artist'] != null ? map['artist'] as String : null,
      albumTitle: map['albumTitle'] != null ? map['albumTitle'] as String : null,
      songUrl: map['songUrl'] as String,
      coverImageUrl: map['coverImageUrl'] != null ? map['coverImageUrl'] as Uint8List : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) => Song.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Song(title: $title, artist: $artist, albumTitle: $albumTitle, songUrl: $songUrl, coverImageUrl: $coverImageUrl)';
  }

  @override
  bool operator ==(covariant Song other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.artist == artist &&
      other.albumTitle == albumTitle &&
      other.songUrl == songUrl &&
      other.coverImageUrl == coverImageUrl;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      artist.hashCode ^
      albumTitle.hashCode ^
      songUrl.hashCode ^
      coverImageUrl.hashCode;
  }
}
