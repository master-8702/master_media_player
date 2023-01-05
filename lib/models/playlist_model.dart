import 'dart:convert';

class Playlist {
  late String title;
  late List<String> songs;
  late String coverImageUrl;

  Playlist(
      {required this.title, required this.songs, required this.coverImageUrl});

  set setSong(List<String> songs) {
    this.songs = songs;
  }

  //stored String to object
  Playlist.fromString(String string) {
    var decode = jsonDecode(string);
    Map<String, dynamic> playlistMap = decode;
    // Playlist playlist = Playlist.fromString(string);
    String temp = playlistMap['songs'];
    List<String> songs = temp.split('~`');

    title = playlistMap['title'];
    this.songs = songs;
    coverImageUrl = playlistMap['coverImage'];
  }

  // here we will override the 'toString' method of object class
  // in order to customize it for our purpose
  @override
  String toString() {
    String songUrls = '';
    for (String songUrlTemp in songs) {
      if (songs.indexOf(songUrlTemp) != 0) {
        songUrls += '~`';
      }
      songUrls += (songUrlTemp);
    }
    songUrls = songUrls.replaceAll('"', '\\"');

    String objectAsString =
        '{"title":"$title", "songs":"$songUrls", "coverImage":"$coverImageUrl"}';

    return objectAsString;
  }
}
