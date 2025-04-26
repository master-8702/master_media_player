import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:path_provider/path_provider.dart';

// This function is used to generate the artwork uri for the songs and playlists
// so that it will be used to display the albumArt in the notification bar
// and lock screen. (the MediaItem object of the AudioSource requires the uri
// of the image file)
Future<Uri> generateArtworkUri({
  required String fallbackAssetPath,
  String? customCoverImagePath,
  Uint8List? embeddedArtwork,
}) async {
  // Generate a unique name for the artwork file using timestamp
  // this is used to avoid caching issue (cover image not updating)
  final timestamp = DateTime.now().microsecondsSinceEpoch.toString();

  try {
    // Get the temporary directory
    final tempDir = await getTemporaryDirectory();
    final artworkFile = File('${tempDir.path}/$timestamp.jpg');

    Uint8List artworkBytes;

    if (embeddedArtwork != null) {
      // Use embedded artwork if available
      artworkBytes = embeddedArtwork;
    } else if (customCoverImagePath != null) {
      // Use custom cover image if provided
      // if the cover image path starts with 'assets/', it means the user
      // didn't assign playlist cover when creating the playlist and the app
      // takes the default playlist cover in the asset directory, so we will
      // load it from assets. Otherwise we will read the user assigned cover image
      // that is stored as Uint8List(bytes) from the file system.
      artworkBytes = customCoverImagePath.startsWith('assets/')
          ? (await rootBundle.load(customCoverImagePath)).buffer.asUint8List()
          : await File(customCoverImagePath).readAsBytes();
    } else {
      // Fallback to default asset if no artwork is available
      artworkBytes =
          (await rootBundle.load(fallbackAssetPath)).buffer.asUint8List();
    }

    // Write the artwork bytes to the temporary file
    await artworkFile.writeAsBytes(artworkBytes);

    // Return the URI of the generated artwork file
    return artworkFile.uri;
  } catch (e) {
    if (!kReleaseMode) {
      debugPrint('Error generating artwork file: ${e.toString()}');
    }
    // Fallback to default asset in case of failure
    final fallbackBytes =
        (await rootBundle.load(fallbackAssetPath)).buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final fallbackFile = File('${tempDir.path}/fallback.jpg');
    await fallbackFile.writeAsBytes(fallbackBytes);
    return fallbackFile.uri;
  }
}
