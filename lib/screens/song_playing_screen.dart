import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mastermediaplayer/components/music_seekbar_slider.dart';
import 'package:mastermediaplayer/components/utilities/utilities.dart';
import 'package:mastermediaplayer/controllers/playlistsController.dart';
import 'package:mastermediaplayer/controllers/timerController.dart';
import '../components/PlayerButtons.dart';
import '../components/PlaylistControlButtons.dart';
import '../components/neumorphic_container.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import '../controllers/favoritesController.dart';
import '../models/song_model.dart';
import 'package:get_storage/get_storage.dart';

class SongPlayingScreen extends StatefulWidget {
  const SongPlayingScreen({Key? key}) : super(key: key);

  @override
  State<SongPlayingScreen> createState() => _SongPlayingScreenState();
}

class _SongPlayingScreenState extends State<SongPlayingScreen> {
  late AudioPlayer audioPlayer;
  Song song = Get.arguments ?? Song.songs[0];

  GetStorage box = GetStorage();
  late List<dynamic> myFavorites;
  final PlaylistsController playlistsController =
      Get.put(PlaylistsController());
  final TextEditingController timerTextEditingController =
      TextEditingController();
  TimerController timerController = TimerController();

  @override
  void initState() {
    audioPlayer = AudioPlayer();

    myFavorites = box.read('myFavorites');

    try {
      // audioPlayer.setFilePath(song.songUrl);

      audioPlayer.setAudioSource(AudioSource.uri(Uri.file(song.songUrl)));
    } catch (e) {
      print("Error loading audio source: $e");
    }
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

// here are gonna use two different streams and we will combine them
  Stream<MusicSliderPositionData> get _musicSliderDragPositionDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, MusicSliderPositionData>(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
        (Duration position, Duration? duration) =>
            MusicSliderPositionData(position, duration ?? Duration.zero),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // to avoid bottom Overflowed error while the keyboard pops up
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // menu and back button
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
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const Text("Now Playing"),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: NeumorphicContainer(
                        child: PopupMenuButton(
                          color: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 10,
                          icon: Icon(
                            Icons.menu_rounded,
                            color: Colors.grey[500],
                            size: 30,
                          ),
                          position: PopupMenuPosition.under,
                          itemBuilder: (context) {
                            return const [
                              PopupMenuItem(
                                value: 'Add To Playlist',
                                child: ListTile(
                                  leading: Icon(Icons.add_circle),
                                  title: Text('Add To Playlist'),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Sleep Timer',
                                child: ListTile(
                                  leading: Icon(Icons.timer_rounded),
                                  title: Text('Sleep Timer'),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Music Info',
                                child: ListTile(
                                  leading: Icon(Icons.info_rounded),
                                  title: Text('Music Info'),
                                ),
                              )
                            ];
                          },
                          onSelected: (selectedValue) {
                            // this future .delayed is added in order to fix the
                            // showdialog and AlertDialog not handling onTap event properly

                            Future.delayed(const Duration(seconds: 0), () {
                              if (selectedValue == 'Add To Playlist') {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AlertDialog(
                                            backgroundColor: Colors.grey[300],
                                            elevation: 6,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            title:
                                                const Text('Add To Playlist'),
                                            content: playlistsController
                                                    .myPlaylists.isEmpty
                                                ? const Center(
                                                    child: Text(
                                                        'No Playlists Yet!'),
                                                  )
                                                : GetBuilder<
                                                        PlaylistsController>(
                                                    builder: (context) {
                                                    return ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          playlistsController
                                                              .myPlaylists
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ListTile(
                                                          onTap: () {
                                                            // here we will add the music to a playlist
                                                            playlistsController
                                                                .addMusicToPlaylist(
                                                                    playlistsController
                                                                        .myPlaylists[index],
                                                                    [
                                                                  song.songUrl
                                                                ]);
                                                          },
                                                          trailing: const Icon(
                                                            Icons.add_circle,
                                                            size: 34,
                                                          ),
                                                          title: Text(
                                                              playlistsController
                                                                  .myPlaylists[
                                                                      index]
                                                                  .title),
                                                          subtitle: Text(
                                                              '${playlistsController.myPlaylists[index].songs.length} songs'),
                                                        );
                                                      },
                                                    );
                                                  }),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Get.toNamed(
                                                        'createPlaylist');
                                                  },
                                                  child: const Text(
                                                      'Create New Playlist'))
                                            ],
                                          ),
                                        ],
                                      );
                                    });
                              } else if (selectedValue == 'Sleep Timer') {
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      timerTextEditingController.text = '';

                                      final formKey = GlobalKey<FormState>();

                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        backgroundColor: Colors.grey[300],
                                        title: const Text('Set Sleep Timer'),
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: SizedBox(
                                                width: 200,
                                                child: Form(
                                                  key: formKey,
                                                  child: TextFormField(
                                                    autofocus: true,
                                                    controller:
                                                        timerTextEditingController,
                                                    decoration:
                                                        const InputDecoration(
                                                      counterText: '',
                                                    ),
                                                    maxLength: 2,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value == '') {
                                                        return 'minute can\'t be empty';
                                                      } else if (!value
                                                          .isNumericOnly) {
                                                        return 'please insert numbers only';
                                                      }
                                                      timerController
                                                          .setDuration(Duration(
                                                              minutes:
                                                                  int.parse(
                                                                      value)));
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Text('Minutes')
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              // here we will validate the user's input for sleep timer
                                              final isTheFormValid = formKey
                                                  .currentState!
                                                  .validate();
                                              if (isTheFormValid) {
                                                // here if the user input is fine (all numeric) we will close the dialog
                                                // and start the sleep timer

                                                Get.back();

                                                timerController
                                                    .startTimer(audioPlayer);
                                              }
                                            },
                                            child: const Text('Start'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                              timerController.stopTimer();
                                            },
                                            child: const Text('Stop'),
                                          ),
                                        ],
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                      );
                                    });
                              } else if (selectedValue == 'Music Info') {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.grey[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        title: const Text('Music Info'),
                                        content: FutureBuilder<Metadata>(
                                          future: MetadataRetriever.fromFile(
                                              File(song.songUrl)),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              Metadata musicInfo =
                                                  snapshot.data as Metadata;
                                              List<String> musicInfo2 =
                                                  musicInfo
                                                      .toString()
                                                      .replaceAll('null', 'NA')
                                                      .split(',')
                                                      .toList();
                                              return ListView.builder(
                                                  itemCount: musicInfo2.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListTile(
                                                        title: Text(
                                                            musicInfo2[index]));
                                                  });
                                            } else if (snapshot.hasError) {
                                              return const Center(
                                                child: Text(
                                                    'Error Occurred! Can not load music info.'),
                                              );
                                            } else {
                                              return const Center(
                                                child:
                                                    Text('Something Happened!'),
                                              );
                                            }
                                          },
                                        ),
                                      );
                                    });
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              // cover art, song name , artist name, album name
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.52,
                width: MediaQuery.of(context).size.width,
                child: NeumorphicContainer(
                  padding: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(alignment: Alignment.topRight, children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: song.coverImageUrl.length == 13
                              ? Image.asset(
                                  'assets/images/music_icon5.png',
                                  fit: BoxFit.fill,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width: MediaQuery.of(context).size.width,
                                )
                              : Image.memory(
                                  song.coverImageUrl,
                                  fit: BoxFit.fill,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              if (timerController.duration.value >
                                  Duration.zero) {
                                return Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(12),
                                        topRight: Radius.circular(12)),
                                    color: Colors.grey[300],
                                  ),
                                  child: Text(
                                    '⏱ ${Utilities.formatDuration(timerController.duration.value)}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                );
                              } else {
                                return const Text('');
                              }
                            }),
                            GetBuilder<FavoritesController>(
                                builder: (favoriteStateController) {
                              return IconButton(
                                icon: Icon(
                                  favoriteStateController.myFavorites
                                          .contains(song.songUrl)
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color: Colors.red,
                                  size: 32,
                                  shadows: const [
                                    BoxShadow(
                                      color: Colors.red,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  if (favoriteStateController.myFavorites
                                      .contains(song.songUrl)) {
                                    favoriteStateController
                                        .removeFavorites(song);
                                  } else {
                                    favoriteStateController.addFavorites(song);
                                  }
                                },
                              );
                            })
                          ],
                        ),
                      ]),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    song.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    song.artist,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              // start time , shuffle button, repeat button, end time
              PlaylistControlButtons(audioPlayer: audioPlayer),
              const SizedBox(
                height: 15,
              ),

              MusicSeekbarSlider(
                audioPlayer: audioPlayer,
                seekBarDataStream: _musicSliderDragPositionDataStream,
              ),

              const SizedBox(
                height: 15,
              ),
              // previous song , ply/pause, next song buttons

              PlayerButtons(audioPlayer: audioPlayer),

              // playing time indicator (progress bar)
            ],
          ),
        ),
      ),
    );
  }
}
