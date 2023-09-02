import 'package:flutter/material.dart';

import 'package:mastermediaplayer/features/favorites/presentation/favoritesController.dart';
import 'package:mastermediaplayer/features/playlists/domain/playlist.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen_controller.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_controller.dart';
import 'package:mastermediaplayer/utilities/file_metadata.dart';

class PlaylistSongCardPopupMenuButton extends StatelessWidget {
  const PlaylistSongCardPopupMenuButton({
    super.key,
    required this.playlistsController,
    required this.playlistPlayingScreenController,
    required this.favoritesController,
    required this.playlist,
    required this.songUrl,
    required this.indexNumber,
  });

  final PlaylistsController playlistsController;
  final PlaylistPlayingScreenController playlistPlayingScreenController;
  final FavoritesController favoritesController;
  final Playlist playlist;
  final String songUrl;
  final int indexNumber;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        position: PopupMenuPosition.under,
        itemBuilder: (context) {
          return [
            if (playlistPlayingScreenController.currentAudioPlayerIndex.value !=
                (indexNumber - 1))
              const PopupMenuItem(
                value: 'Remove from Playlist',
                child: Text('Remove from Playlist'),
              ),
            const PopupMenuItem(
              value: 'Add to My Favorites',
              child: Text('Add to My Favorites'),
            ),
          ];
        },
        onSelected: (String value) async {
          // here in the pop up menu options we will remove the selected song from the playlist
          // or add it to the favorites list based on the user's selection

          if (value == 'Remove from Playlist') {
            playlistsController
                .addOrRemoveSongsFromPlaylist(playlist, [songUrl]);
          }
          if (value == 'Add to My Favorites') {
            favoritesController
                .addOrRemoveFavorites(await FileMetadata().getSong(songUrl));
          }
        });
  }
}
