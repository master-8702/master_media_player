import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';
import 'package:mastermediaplayer/common/controllers/theme_controller.dart';

// this class will build our settings page screen

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                Expanded(
                  child: Text("Settings",
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            NeumorphicContainer(
              padding: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DarkMode',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Switch(
                    activeColor: Colors.white,
                    value: themeController.isDarkModeOn(),
                    onChanged: (darkMode) {
                      if (darkMode) {
                        themeController.changeThemeMode(ThemeMode.dark);
                      } else {
                        themeController.changeThemeMode(ThemeMode.light);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            NeumorphicContainer(
                padding: 5,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Warning'),
                              content: const Text(
                                  'Are You Sure You Want To Delete All Your Playlist and Favorite Musics List From The Local Storage'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      GetStorage().erase();
                                      Get.back();
                                    },
                                    child: const Text('Confirm')),
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text('Cancel'))
                              ],
                            );
                          });
                    },
                    child: const Text(
                      'Delete All Playlists & Favorites',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                )),
            const Spacer(),
            Column(
              children: [
                Divider(
                  thickness: 5,
                  indent: 20,
                  endIndent: 20,
                  color: Theme.of(context).colorScheme.secondary,
                  height: 20,
                ),
                const Text(
                  "Developed By IBS",
                  style: TextStyle(fontSize: 30),
                ),
                Divider(
                  thickness: 5, // thickness of the line
                  indent: 20, // empty space to the leading edge of divider.
                  endIndent:
                      20, // empty space to the trailing edge of the divider.
                  color: Theme.of(context)
                      .colorScheme
                      .secondary, // The color to use when painting the line.
                  height: 20, // The divider's height extent.
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
