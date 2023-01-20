import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/components/playlist_card.dart';
import 'package:mastermediaplayer/components/song_card2.dart';
import 'package:mastermediaplayer/models/song_model.dart';

import '../components/neumorphic_container.dart';
import '../utilities/utilities.dart';
import '../controllers/playlistsController.dart';
import '../models/playlist_model.dart';
import '../models/searchable_playlist_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final PlaylistsController playlistsController =
      Get.put(PlaylistsController());
  TextEditingController textEditingController = TextEditingController();

  // in the following two variables we will put the search results from musics and playlists respectively
  var foundSongs = <SearchablePlaylist>[].obs;
  var foundPlaylist = <Playlist>[].obs;

  // this method will help in searching specific musics and playlist from the total playlists file.
  // and it's gonna search the 'songTitle', 'artistName' & 'albumName' from each individual music files that's is gonna match
  // the search query, from the songs of all playlists
  // and 'playlistTitle' from all playlists.
  void playlistSearcher(String searchQuery) async {
    var myPlaylist2 = playlistsController.myPlaylists;
    // here first we will convert all playlists to SearchablePlaylist
    List<SearchablePlaylist> searchablePlaylists = [];
    for (int i = 0; i < myPlaylist2.length; i++) {
      for (int j = 0; j < myPlaylist2[i].songs.length; j++) {
        Metadata metaData =
            await MetadataRetriever.fromFile(File(myPlaylist2[i].songs[j]));
        SearchablePlaylist searchablePlaylist = SearchablePlaylist(
            albumTitle: metaData.albumName ?? 'Unknown Album',
            artistName: metaData.trackArtistNames != null
                ? metaData.trackArtistNames!.toList().toString()
                : 'Unknown Artist',
            playlistIndex: i,
            songIndex: j,
            songTitle: Utilities.basename(File(myPlaylist2[i].songs[j])));
        searchablePlaylists.add(searchablePlaylist);
      }
    }
    // here we will put search results from each search types like from songTitle, artisNames, playlistTitle separately...
    // then we will concatenate them in a single list (all related to musics) and another list for playlist related results
    // based on their importance probability in the following order: first result from songTitle then artistName then albumName then Playlist title
    var foundResultFromSongTitles = searchablePlaylists
        .where((element) =>
            element.songTitle.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    var foundResultFromArtistNames = searchablePlaylists
        .where((element) => element.artistName.contains(searchQuery))
        .toList();

    var foundResultFromAlbumTitles = searchablePlaylists
        .where((element) => element.albumTitle.contains(searchQuery))
        .toList();
    var foundResultFromPlaylistTitles = playlistsController.myPlaylists
        .where((element) => element.title.contains(searchQuery))
        .toList();

    foundSongs.value = [
      ...foundResultFromSongTitles,
      ...foundResultFromArtistNames,
      ...foundResultFromAlbumTitles,
    ];
    foundPlaylist.value = [...foundResultFromPlaylistTitles];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: NeumorphicContainer(
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_rounded,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: NeumorphicContainer(
                        padding: 5,
                        child: TextField(
                          autofocus: true,
                          controller: textEditingController,
                          decoration: InputDecoration(
                              hintText: 'search your playlists',
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    if (textEditingController.text.isEmpty) {
                                    } else {
                                      playlistSearcher(
                                          textEditingController.text);
                                    }
                                  },
                                  icon: const Icon(Icons.search))),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                // and here in this Obx(Observable widget from GetX) we will display the search result
                // or a little funny 'no result found' message
                child: Obx(() {
                  if (textEditingController.text.isNotEmpty &&
                      foundSongs.isEmpty &&
                      foundPlaylist.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'I don\'t know any music or playlist\n  by that name!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                            child: Image.asset(
                                height: 150,
                                width: 150,
                                'assets/images/you_are_not_drunk.png')),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'You are not drunk, right?',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    );
                  } else if (foundSongs.isNotEmpty) {
                    // here by using the builder constructor of ListView we will normally display the search results that are only
                    // music related (foundSongs) and when the the builder is at the last iteration then we will add the 'playlist related'
                    // search results (foundPlaylist)s to the end of the existing list (in the column) after adding the last item from foundSongs

                    return ListView.builder(
                        itemCount: foundSongs.length,
                        itemBuilder: (context, index) {
                          var temp = foundSongs[index];

                          // the below code will be displayed if the builder is on the last iteration
                          if (index == foundSongs.length - 1) {
                            return Column(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    Get.toNamed('playlist', arguments: {
                                      'playlist':
                                          playlistsController.myPlaylists[
                                              foundSongs[index].playlistIndex],
                                      'selectedIndex':
                                          foundSongs[index].songIndex
                                    });
                                  },
                                  child: IgnorePointer(
                                    child: SongCard2(
                                        song: Song(
                                            title: temp.songTitle,
                                            artist: temp.artistName,
                                            albumTitle: temp.albumTitle,
                                            songUrl: '',
                                            coverImageUrl: Uint8List(13))),
                                  ),
                                ),
                                // here we are adding the 'foundPlaylists' list at the end of the 'foundSongs' list
                                // and since we set the listView setting to NeverScroll it wont be another list
                                // it will just use the above list's scrolling function and they will just act like a single list
                                ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: foundPlaylist
                                      .map((element) =>
                                          PlaylistCard(myPlaylist: element))
                                      .toList(),
                                ),
                              ],
                            );
                          }
                          // the below code will be executed when the builder starts building lists and is not on the last
                          // iteration (normal condition) .. but when it hits it's last index only the above code will be executed.
                          return GestureDetector(
                            // here setting behavior property of GestureDetector to 'HitTestBehavior.opaque' will allow us
                            // to override the child's onTap or onPressed methods with the help of IgnorePointer widget
                            // so to do that just wrap the child widget with IgnorePointer and wrap IgnorePointer with a GestureDetector
                            // after that we can handle any event we want from the 'onTap' method of the GestureDetector
                            // without worrying about any Gesture Handling from the child widget
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Get.toNamed('playlist', arguments: {
                                'playlist': playlistsController.myPlaylists[
                                    foundSongs[index].playlistIndex],
                                'selectedIndex': foundSongs[index].songIndex
                              });
                            },
                            child: IgnorePointer(
                              child: SongCard2(
                                  song: Song(
                                      title: temp.songTitle,
                                      artist: temp.artistName,
                                      albumTitle: temp.albumTitle,
                                      songUrl: '',
                                      coverImageUrl: Uint8List(13))),
                            ),
                          );
                        });
                  } else {
                    // here 'else' means when foundSongs is empty we don't need to append the foundPlaylist to the foundSongs
                    // so we will just display it as a normal independent list with it's own scrolling function and lazyLoad behavior
                    return ListView(
                      children: foundPlaylist
                          .map((element) => PlaylistCard(myPlaylist: element))
                          .toList(),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
