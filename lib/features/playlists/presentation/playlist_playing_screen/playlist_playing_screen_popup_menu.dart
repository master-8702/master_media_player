import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/controllers/timerController.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_controller.dart';

class PlaylistPlayingScreenPopupMenu extends StatelessWidget {
  const PlaylistPlayingScreenPopupMenu({
    super.key,
    required this.playlistsController,
    required this.playlistPlayingScreenController,
    required this.timerTextEditingController,
    required this.timerController,
  });

  final PlaylistsController playlistsController;
  final PlaylistPlayingScreenController playlistPlayingScreenController;
  final TextEditingController timerTextEditingController;
  final TimerController timerController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: NeumorphicContainer(
        child: PopupMenuButton(
          icon: const Icon(Icons.menu_rounded),
          position: PopupMenuPosition.under,
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
          onSelected: (selectedValue) async {
            if (selectedValue == 'Add Music(s)') {
              playlistsController.selectedSongs =
                  await Get.toNamed('selectableSongExplorer');

              playlistsController.addOrRemoveSongsFromPlaylist(
                  playlistPlayingScreenController.myPlaylist.value,
                  playlistsController.selectedSongs);
            } else if (selectedValue == 'Sleep Timer') {
              return _sleepTimerAlertDialog(context);
            }
          },
        ),
      ),
    );
  }


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  Future<void> _sleepTimerAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          timerTextEditingController.text = '';

          final formKey = GlobalKey<FormState>();

          return AlertDialog(
            title: const Text('Set Sleep Timer'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 200,
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        autofocus: true,
                        controller: timerTextEditingController,
                        decoration: const InputDecoration(
                          counterText: '',
                        ),
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'minute can\'t be empty';
                          } else if (!value.isNumericOnly) {
                            return 'please insert numbers only';
                          }
                          timerController
                              .setDuration(Duration(minutes: int.parse(value)));
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
                  final isTheFormValid = formKey.currentState!.validate();
                  if (isTheFormValid) {
                    // here if the user input is fine (all numeric) we will close the dialog
                    // and start the sleep timer

                    Get.back();

                    timerController.startTimer(
                        playlistPlayingScreenController.audioPlayer);
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
            actionsAlignment: MainAxisAlignment.center,
          );
        });
  }
}
