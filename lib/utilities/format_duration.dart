 
 /// To covert the duration(in int format) returned by the audioPlayer into 
 /// a more suitable format (eg: 04:38) for displaying and for the user. 
 String formatDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    } else {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }
  }