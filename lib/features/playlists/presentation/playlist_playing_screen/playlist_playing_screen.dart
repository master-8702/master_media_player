import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:text_scroll/text_scroll.dart';

import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_controller.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';
import '../../../../components/PlayerButtons.dart';
import '../../../../components/PlaylistControlButtons.dart';
import '../../../../components/music_seekbar_slider.dart';
import '../../../../components/neumorphic_container.dart';
import '../../../../components/playlist_songs.dart';

import '../../../../controllers/timerController.dart';

// this class is going to be used for displaying a single playlist page UI with a list of songs from that playlist
class PlaylistPlayingScreen extends StatefulWidget {
  const PlaylistPlayingScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistPlayingScreen> createState() => _PlaylistPlayingScreenState();
}

class _PlaylistPlayingScreenState extends State<PlaylistPlayingScreen> {
  final PlaylistPlayingScreenController singlePlaylistController =
      Get.put(PlaylistPlayingScreenController());
  final playlistsController = Get.find<PlaylistsController>();

  final TextEditingController timerTextEditingController =
      TextEditingController();
  TimerController timerController = TimerController();

  @override
  Widget build(BuildContext context) {
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
                            singlePlaylistController.myPlaylist.value.title,
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
                              playlistsController.selectedSongs =
                                  await Get.toNamed('selectableSongExplorer');
                              playlistsController.addOrRemoveSongsFromPlaylist(
                                  singlePlaylistController.myPlaylist.value,
                                  playlistsController.selectedSongs);
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

                                              timerController.startTimer(
                                                  singlePlaylistController
                                                      .audioPlayer);
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
                            child: singlePlaylistController
                                        .myPlaylist.value.coverImageUrl ==
                                    'assets/images/playlist.png'
                                ? Image.asset(
                                    singlePlaylistController
                                        .myPlaylist.value.coverImageUrl,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(singlePlaylistController
                                        .myPlaylist.value.coverImageUrl),
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
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
                            File(
                                singlePlaylistController.myPlaylist.value.songs[
                                    singlePlaylistController
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
                    PlaylistControlButtons(
                        audioPlayer: singlePlaylistController.audioPlayer),
                    const SizedBox(
                      height: 15,
                    ),
                    MusicSeekbarSlider(
                      audioPlayer: singlePlaylistController.audioPlayer,
                      seekBarDataStream: singlePlaylistController
                          .musicSliderDragPositionDataStream,
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    // previous song , ply/pause, next song buttons

                    PlayerButtons(
                      audioPlayer: singlePlaylistController.audioPlayer,
                      singlePlaylistController: singlePlaylistController,
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(
                  height: 15,
                ),
                Obx(() {
                  return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      clipBehavior: Clip.none,
                      itemCount: singlePlaylistController
                          .myPlaylist.value.songs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            await singlePlaylistController.audioPlayer
                                .seek(Duration.zero, index: index);
                            singlePlaylistController.currentAudioPlayerIndex
                                .value = singlePlaylistController
                                    .audioPlayer.currentIndex ??
                                0;
                          },
                          child: Obx(
                            () => PlaylistSongs(
                                playlist:
                                    singlePlaylistController.myPlaylist.value,
                                indexNumber: index + 1,
                                songUrl: singlePlaylistController
                                    .myPlaylist.value.songs[index]),
                          ),
                        );
                      });
                  // this music player app is developed by master
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
