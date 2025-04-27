import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';

/// this function is used to extract the embedded artwork from the audio file
/// and return it as a Uint8List. and if there isn't any embedded artwork
/// then we will return the default artwork from assets.
Future<Uint8List> extractEmbeddedArtwork(File audioFile) async {
  try {
    // Use audio_metadata_reader package [[2]]
    final metadata = readMetadata(audioFile, getImage: true);

    if (metadata.pictures.isNotEmpty) {
      return metadata.pictures.first.bytes;
    }
  } catch (e) {
    if (!kReleaseMode) {
      debugPrint('error: can not extract embedded artwork. \n ${e.toString()}');
    }
    // Fallback if extraction fails
  }

  // Return default artwork if no embedded art found
  return (await rootBundle.load('assets/images/music_icon5.png'))
      .buffer
      .asUint8List();
}
