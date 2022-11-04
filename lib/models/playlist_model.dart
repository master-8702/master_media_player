import 'package:mastermediaplayer/models/song_model.dart';

class Playlist {
  final String title;
  final List<Song> songs;
  final String coverImageUrl;

  Playlist(
      {required this.title, required this.songs, required this.coverImageUrl});

  static List<Playlist> myPlaylists = [
    Playlist(
        title: "Ustaz Bedru Hussein",
        songs: Song.songs,
        coverImageUrl: 'assets/images/bedru.jpg'),
    Playlist(
        title: "Engurguro",
        songs: Song.songs,
        coverImageUrl: 'assets/images/engurguro.jpg'),
    Playlist(
        title: "Medh",
        songs: Song.songs,
        coverImageUrl: 'assets/images/medh.png'),
    Playlist(
        title: "Ustaz Abubeker Ahmed",
        songs: Song.songs,
        coverImageUrl: 'assets/images/abubeker.jpg'),
    Playlist(
        title: "Sheyk Abdurahman As-Sudais",
        songs: Song.songs,
        coverImageUrl: 'assets/images/sudais.jpg'),
    Playlist(
        title: "Ustaz Yasin Nuru",
        songs: Song.songs,
        coverImageUrl: 'assets/images/yasin.jpg'),
    Playlist(
        title: "Maher Zain",
        songs: Song.songs,
        coverImageUrl: 'assets/images/maher.jpg'),
    Playlist(
        title: "Ustaz Nouman ALi Khan",
        songs: Song.songs,
        coverImageUrl: 'assets/images/nouman.jpg'),
    Playlist(
        title: "Ustaz Mufti Menk",
        songs: Song.songs,
        coverImageUrl: 'assets/images/mufti.jpg'),
    Playlist(
        title: "Ahmed Al-Ajmy",
        songs: Song.songs,
        coverImageUrl: 'assets/images/ahmed.jpg'),
    Playlist(
        title: "Tewfeeq Al-Sayegh",
        songs: Song.songs,
        coverImageUrl: 'assets/images/tewfeeq.jpg'),
    Playlist(
        title: "Hamood AL Khuder",
        songs: Song.songs,
        coverImageUrl: 'assets/images/hamood.jpg'),
    Playlist(
        title: "Muaz Habib",
        songs: Song.songs,
        coverImageUrl: 'assets/images/muaz.jpg'),
    Playlist(
        title: "Neshidas",
        songs: Song.songs,
        coverImageUrl: 'assets/images/neshida.jpg'),
    Playlist(
        title: "Sami Yusuf",
        songs: Song.songs,
        coverImageUrl: 'assets/images/sami.jpg'),
  ];
}
