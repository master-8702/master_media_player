import 'dart:typed_data';

class Song {
  final String title;
  final String artist;
  final String albumTitle;
  final String songUrl;
  final Uint8List coverImageUrl;

  Song({
    required this.title,
    required this.artist,
    required this.albumTitle,
    required this.songUrl,
    required this.coverImageUrl,
  });
}
