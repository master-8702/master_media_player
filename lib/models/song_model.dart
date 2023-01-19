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

  static List<Song> songs = [
    Song(
      title: "Alfu Selat",
      artist: 'Fuad Alburda',
      albumTitle: 'Engurguro + Dibe menzuma',
      songUrl: 'assets/audios/alfuSelat.mp3',
      coverImageUrl: Uint8List(13),
    ),
    Song(
      title: 'Arhibu Nebye',
      artist: 'Anwar Alburda',
      albumTitle: 'Engurguro + Dibe menzuma',
      songUrl: 'assets/audios/arhibuNebye.mp3',
      coverImageUrl: Uint8List(13),
    ),
    Song(
      title: 'Enes Kenahubet',
      artist:
          'Husni Sultan, Sualih Muhammed, Ashref Nasir, Abdurezak Tewfik, Selahadin',
      albumTitle: 'Engurguro + Neshida',
      songUrl: 'assets/audios/enesKenahubet.mp3',
      coverImageUrl: Uint8List(13),
    ),
    Song(
      title: "Alfu Selat",
      artist: 'Fuad Alburda',
      albumTitle: 'Engurguro + Dibe menzuma',
      songUrl: 'assets/audios/alfuSelat.mp3',
      coverImageUrl: Uint8List(13),
    ),
    Song(
      title: 'Arhibu Nebye',
      artist: 'Anwar Alburda',
      albumTitle: 'Engurguro + Dibe menzuma',
      songUrl: 'assets/audios/arhibuNebye.mp3',
      coverImageUrl: Uint8List(13),
    ),
    Song(
      title: 'Enes Kenahubet',
      artist:
          'Husni Sultan, Sualih Muhammed, Ashref Nasir, Abdurezak Tewfik, Selahadin',
      albumTitle: 'Engurguro + Neshida',
      songUrl: 'assets/audios/enesKenahubet.mp3',
      coverImageUrl: Uint8List(13),
    )
  ];
}
