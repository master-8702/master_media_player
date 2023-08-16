import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mastermediaplayer/features/player/domain/music_slider_position_data.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';
import 'package:mastermediaplayer/models/playlist_model.dart';
import 'package:text_scroll/text_scroll.dart';
import '../components/PlayerButtons.dart';
import '../components/PlaylistControlButtons.dart';
import '../components/music_seekbar_slider.dart';
import '../components/neumorphic_container.dart';
import '../components/playlist_songs.dart';
import '../controllers/playlistsController.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import '../controllers/timerController.dart';

// this class is going to be used for displaying a single playlist page UI with a list of songs from that playlist
class SinglePlaylistScreen extends StatefulWidget {
  const SinglePlaylistScreen({Key? key}) : super(key: key);

  @override
  State<SinglePlaylistScreen> createState() => _SinglePlaylistScreenState();
}

class _SinglePlaylistScreenState extends State<SinglePlaylistScreen> {
  Playlist myPlaylist = Get.arguments['playlist'];
  // if the selected index is passed as an argument we will take that otherwise we will just initialize it to zero
  int selectedSongIndex = Get.arguments['selectedIndex'] ?? 0;

  AudioPlayer audioPlayer = AudioPlayer();
  late var selectedSongs = <String>[].obs;

  final PlaylistsController playlistsController =
      Get.put(PlaylistsController());

  final TextEditingController timerTextEditingController =
      TextEditingController();
  TimerController timerController = TimerController();

  @override
  void initState() {
    // here we will initialize the index to zero cause the last playlist's index might not be found on the new one
    // so we will avoid range error (index out of range error)
    // on the other hand if we came from the search page the index might not be zero so using selectedSongIndex variable
    // we will check if we came from the playlists page or search page (if we came from the search page probably it won't be a zero)
    // and assign the initial index number for the playlist audio source.
    playlistsController.currentAudioPlayerIndex.value = selectedSongIndex;
    // here we will concatenate audio sources to the player from the playlist song's file
    List<AudioSource> audioSources = [];
    for (String songPath in myPlaylist.songs) {
      audioSources.add(AudioSource.uri(Uri.file(songPath)));
    }
    final playlist = ConcatenatingAudioSource(
        children: audioSources,
        shuffleOrder: DefaultShuffleOrder(),
        useLazyPreparation: true);
    audioPlayer.setAudioSource(playlist,
        initialIndex: selectedSongIndex, initialPosition: Duration.zero);

    super.initState();
  }

  // here we are gonna use two different streams and we will combine them using rxdart package
  Stream<MusicSliderPositionData> get _musicSliderDragPositionDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, MusicSliderPositionData>(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
        (Duration position, Duration? duration) =>
            MusicSliderPositionData(position, duration ?? Duration.zero),
      );

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    audioPlayer.play();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            myPlaylist.title,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: NeumorphicContainer(
                        child: PopupMenuButton(
                          position: PopupMenuPosition.under,
                          onSelected: (selectedValue) async {
                            if (selectedValue == 'Add Music(s)') {
                              selectedSongs =
                                  await Get.toNamed('selectableSongExplorer');
                              playlistsController.addMusicToPlaylist(
                                  myPlaylist, selectedSongs);
                            } else if (selectedValue == 'Sleep Timer') {
                              return showDialog(
                                  context: context,
                                  builder: (context) {
                                    timerTextEditingController.text = '';

                                    final formKey = GlobalKey<FormState>();

                                    return AlertDialog(
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
                                                    timerController.setDuration(
                                                        Duration(
                                                            minutes: int.parse(
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
                            }
                          },
                          itemBuilder: (context) {
                            return const [
                              PopupMenuItem(
                                value: 'Add Music(s)',
                                child: ListTile(
                                  leading: Icon(Icons.add),
                                  title: Text('Add Music(s)'),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Sleep Timer',
                                child: ListTile(
                                  leading: Icon(Icons.timer_rounded),
                                  title: Text('Sleep Timer'),
                                ),
                              )
                            ];
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.33,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(alignment: Alignment.topCenter, children: [
                    NeumorphicContainer(
                      padding: 10,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: myPlaylist.coverImageUrl ==
                                    'assets/images/playlist.png'
                                ? Image.asset(
                                    myPlaylist.coverImageUrl,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fill,
                                  )
                                : Expanded(
                                    child: Image.file(
                                      File(myPlaylist.coverImageUrl),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
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
                                  color: Theme.of(context).backgroundColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '⏱ ${Utilities.formatDuration(timerController.duration.value)}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              );
                            } else {
                              return const Text('');
                            }
                          }),
                        ],
                      ),
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 15,
                ),
                Obx(
                  () => NeumorphicContainer(
                    padding: 10,
                    child: Column(
                      children: [
                        const Text('Now Playing:'),
                        const SizedBox(
                          height: 10,
                        ),
                        TextScroll(
                          Utilities.basename(
                            File(myPlaylist.songs[playlistsController
                                .currentAudioPlayerIndex.value]),
                          ),
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          velocity:
                              const Velocity(pixelsPerSecond: Offset(30, 30)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                  ],
                ),
                const Divider(),
                const SizedBox(
                  height: 15,
                ),
                GetBuilder<PlaylistsController>(builder: (context) {
                  return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      clipBehavior: Clip.none,
                      itemCount: myPlaylist.songs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            audioPlayer.seek(Duration.zero, index: index);
                            playlistsController.justRebuildTheUi(index);
                          },
                          child: PlaylistSongs(
                              playingStatus: playlistsController
                                      .currentAudioPlayerIndex.value ==
                                  index,
                              playlist: myPlaylist,
                              indexNumber: index + 1,
                              songUrl: myPlaylist.songs[index]),
                        );
                      });
                  // this music player app is developed by master

                  //
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
