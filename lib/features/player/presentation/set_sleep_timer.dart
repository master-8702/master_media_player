import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/features/player/presentation/song_playing_screen_controller.dart';

// this function will show a dialog to set the sleep timer
// it will show a text field to enter the time in minutes
Future<void> setSleepTimer(
    BuildContext context, SongPlayingScreenController controller) async {
  await showDialog(
      context: context,
      builder: (context) {
        controller.timerTextEditingController.text = '';

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
                      controller: controller.timerTextEditingController,
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
                        controller.timerController.value
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

                  controller.timerController.value
                      .startTimer(controller.audioPlayer.value);
                }
              },
              child: const Text('Start'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                controller.timerController.value.stopTimer();
              },
              child: const Text('Stop'),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      });
}
