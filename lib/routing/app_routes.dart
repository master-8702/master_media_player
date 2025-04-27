import 'package:get/get.dart';
import 'package:mastermediaplayer/common/screens/home_screen.dart';
import 'package:mastermediaplayer/common/screens/settings_screen.dart';
import 'package:mastermediaplayer/features/player/presentation/song_playing_screen.dart';
import 'package:mastermediaplayer/features/favorites/presentation/favorites_screen.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlists_screen.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/image_explorer_screen.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/music_explorer_screen.dart';
import 'package:mastermediaplayer/features/file_explorer/presentation/selectable_song_explorer_screen.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_search/playlist_search_screen.dart';
import 'package:mastermediaplayer/features/playlists/presentation/create_playlist_screen/create_playlist_screen.dart';
import 'package:mastermediaplayer/features/playlists/presentation/playlist_playing_screen/playlist_playing_screen.dart';

// App route enums will help us to avoid typos
enum AppRoute {
  home('/'),
  songPlayingScreen('/songPlayingScreen'),
  playlistPlayingScreen('/playlistPlayingScreen'),
  fileExplorer('/fileExplorer'),
  selectableSongExplorer('/selectableSongExplorer'),
  imageExplorer('/imageExplorer'),
  playlists('/PlaylistsScreen'),
  createPlaylist('/createPlaylist'),
  favorites('/favoritesScreen'),
  search('/search'),
  settings('/settings');

// since Getx routing needs the page names that we pass to the GetPage constructor
// to have '/' as a prefix, here we are overriding the enum constructor to accept strings
  final String path;
  const AppRoute(this.path);
}

List<GetPage> getPageRoutes() {
  return [
    GetPage(
      name: AppRoute.home.path,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoute.songPlayingScreen.path,
      page: () => const SongPlayingScreen(),
    ),
    GetPage(
      name: AppRoute.playlistPlayingScreen.path,
      page: () => const PlaylistPlayingScreen(),
    ),
    GetPage(
      name: AppRoute.fileExplorer.path,
      page: () => const MusicExplorerScreen(),
    ),
    GetPage(
      name: AppRoute.selectableSongExplorer.path,
      page: () => const SelectableSongExplorerScreen(),
    ),
    GetPage(
      name: AppRoute.imageExplorer.path,
      page: () => const ImageExplorerScreen(),
    ),
    GetPage(
      name: AppRoute.playlists.path,
      page: () => PlaylistsScreen(),
    ),
    GetPage(
      name: AppRoute.createPlaylist.path,
      page: () => CreatePlaylistScreen(),
    ),
    GetPage(
      name: AppRoute.favorites.path,
      page: () => FavoritesScreen(),
    ),
    GetPage(
      name: AppRoute.search.path,
      page: () => PlaylistSearchScreen(),
    ),
    GetPage(
      name: AppRoute.settings.path,
      // this is for testing purposes we will return the correct page
      page: () => SettingsScreen(),
    ),
  ];
}
