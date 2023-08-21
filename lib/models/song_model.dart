// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

class Song {
  final String title;
  final String artist;
  final String albumTitle;
  final String songUrl;
  final Uint8List? coverImageUrl;

  Song({
    required this.title,
    this.artist = 'Unknown Artist',
    this.albumTitle = 'Unknown Album',
    required this.songUrl,
    this.coverImageUrl,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'artist': artist,
      'albumTitle': albumTitle,
      'songUrl': songUrl,
      // 'coverImageUrl': coverImageUrl != null ? convertUint8ListToString(coverImageUrl!): null,
      'coverImageUrl': convertUint8ListToString(coverImageUrl),
    };
  }


  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      title: map['title'] as String,
      artist: map['artist'] as String,
      albumTitle: map['albumTitle'] as String,
      songUrl: map['songUrl'] as String,
      coverImageUrl: map['coverImageUrl'] != null
          ? convertStringToUint8List(map['coverImageUrl'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) =>
      Song.fromMap(json.decode(source) as Map<String, dynamic>);



  static Uint8List? convertStringToUint8List(String? str) {
    if (str != null) {
      if (str.length <= 13) {
        return Uint8List(13);
      } else {
        final List<int> codeUnits = str.codeUnits;
        final Uint8List unit8List = Uint8List.fromList(codeUnits);

        return unit8List;
      }
    } else {
      return Uint8List(13);
    }
  }

  static String? convertUint8ListToString(Uint8List? uint8list) {
    if (uint8list != null) {
      if (uint8list.length > 13) {
        return String.fromCharCodes(uint8list);
      } else {
        return String.fromCharCodes(Uint8List(13));
      }
    } else {
      return String.fromCharCodes(Uint8List(13));
    }
  }

  @override
  bool operator ==(covariant Song other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.artist == artist &&
        other.albumTitle == albumTitle &&
        other.songUrl == songUrl; // &&
    // other.coverImageUrl == coverImageUrl;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        artist.hashCode ^
        albumTitle.hashCode ^
        songUrl.hashCode ^
        coverImageUrl.hashCode;
  }

  @override
  String toString() {
    return 'Song(title: $title, artist: $artist, albumTitle: $albumTitle, songUrl: $songUrl, coverImageUrl: $coverImageUrl)';
  }
}
