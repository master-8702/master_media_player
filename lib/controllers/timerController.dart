import 'dart:async';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class TimerController extends GetxController {
  var duration = Duration.zero.obs;
  late Timer timer;

  // this is gonna set our sleep timer duration
  void setDuration(Duration d) {
    duration.value = d;
    update();
  }

  // this method is going to return the current time or duration of the sleep timer
  Duration getTimer() {
    return duration.value;
  }

  // this method will help us to start the timer
  void startTimer(AudioPlayer audioPlayer) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateTimer(audioPlayer);
    });
  }

  // this method will help us to stop the timer
  void stopTimer() {
    duration.value = Duration.zero;
    // here we need to cancel the timer as well because since the timer is active even we set the duration to zero
    // it will still call updateTimer and pause the audio, which is what we don't want to happen (we're just canceling the timer)
    timer.cancel();
  }

  // this method will help to reset the timer to default time, which is Duration.zero and update the UI
  void resetTimer() {
    duration.value = Duration.zero;
    update();
  }

  // this method is going to update the timer
  void updateTimer(AudioPlayer audioPlayer) {
    if (duration.value == Duration.zero) {
      // here in addition to stopping the audioPlayer we need to cancel the timer that is still running every second and
      // it will pause the player immediately even after we pressed play after the sleep time is over
      timer.cancel();
      audioPlayer.stop();
    } else if (duration.value >= Duration.zero) {
      duration.value = Duration(seconds: duration.value.inSeconds - 1);
    }
    // here the calling of update method of GetX is gonna initiate UI rebuild of the timer display widget
    update();
  }
}
