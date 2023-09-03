import 'package:get/get.dart';
import 'package:mastermediaplayer/common/screens/home_screen.dart';
import 'package:mastermediaplayer/common/screens/settings_screen.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favorites_screen.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/image_explorer_screen.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/music_explorer_screen.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/selectable_song_explorer_screen.dart';
import 'package:mastermediaplayer/features/player/presentation/song_playing_screen.dart';
import 'package:mastermediaplayer/features/playlists/presentation/create_playlist_screen/create_playlist_screen.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_search/playlist_search_screen.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_screen.dart';

List<GetPage> getPageRoutes() {
  return [
    GetPage(
      name: '/',
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: '/songPlaying',
      page: () => SongPlayingScreen(),
    ),
    GetPage(
      name: '/playlist',
      page: () => const PlaylistPlayingScreen(),
    ),
    GetPage(
      name: '/fileExplorer',
      page: () => const MusicExplorerScreen(),
    ),
    GetPage(
      name: '/selectableSongExplorer',
      page: () => const SelectableSongExplorerScreen(),
    ),
    GetPage(
      name: '/imageExplorer',
      page: () => ImageExplorerScreen(),
    ),
    GetPage(
      name: '/playlists',
      page: () => PlaylistsScreen(),
    ),
    GetPage(
      name: '/createPlaylist',
      page: () => CreatePlaylistScreen(),
    ),
    GetPage(
      name: '/favorites',
      page: () => FavoritesScreen(),
    ),
    GetPage(
      name: '/search',
      page: () => PlaylistSearchScreen(),
    ),
    GetPage(
      name: '/settings',
      // this is for testing purposes we will return the correct page
      page: () => SettingsScreen(),
    ),
  ];
}
