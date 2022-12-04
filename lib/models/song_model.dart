class Song {
  final String title;
  final String singer;
  final String description;
  final String songUrl;
  final String coverImageUrl;

  Song(
      {required this.title,
      required this.singer,
      required this.description,
      required this.songUrl,
      this.coverImageUrl = 'assets/images/music_icon.png'});

  static List<Song> songs = [
    Song(
      title: "Alfu Selat",
      singer: 'Fuad Alburda',
      description: 'Engurguro + Dibe menzuma',
      songUrl: 'assets/audios/alfuSelat.mp3',
      coverImageUrl: 'assets/images/alfuSelat.png',
    ),
    Song(
        title: 'Arhibu Nebye',
        singer: 'Anwar Alburda',
        description: 'Engurguro + Dibe menzuma',
        songUrl: 'assets/audios/arhibuNebye.mp3',
        coverImageUrl: 'assets/images/arhibuNebye.png'),
    Song(
        title: 'Enes Kenahubet',
        singer:
            'Husni Sultan, Sualih Muhammed, Ashref Nasir, Abdurezak Tewfik, Selahadin',
        description: 'Engurguro + Neshida',
        songUrl: 'assets/audios/enesKenahubet.mp3',
        coverImageUrl: 'assets/images/enesKenahubet.png'),
    Song(
      title: "Alfu Selat",
      singer: 'Fuad Alburda',
      description: 'Engurguro + Dibe menzuma',
      songUrl: 'assets/audios/alfuSelat.mp3',
      coverImageUrl: 'assets/images/alfuSelat.png',
    ),
    Song(
        title: 'Arhibu Nebye',
        singer: 'Anwar Alburda',
        description: 'Engurguro + Dibe menzuma',
        songUrl: 'assets/audios/arhibuNebye.mp3',
        coverImageUrl: 'assets/images/arhibuNebye.png'),
    Song(
        title: 'Enes Kenahubet',
        singer:
            'Husni Sultan, Sualih Muhammed, Ashref Nasir, Abdurezak Tewfik, Selahadin',
        description: 'Engurguro + Neshida',
        songUrl: 'assets/audios/enesKenahubet.mp3',
        coverImageUrl: 'assets/images/enesKenahubet.png'),
  ];
}
