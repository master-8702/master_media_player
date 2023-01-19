class SearchablePlaylist {
  late int playlistIndex;
  late int songIndex;
  late String songTitle;
  late String albumTitle;
  late String artistName;

  SearchablePlaylist(
      {required this.playlistIndex,
      required this.songIndex,
      required this.songTitle,
      required this.albumTitle,
      required this.artistName});
}
