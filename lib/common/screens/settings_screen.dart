import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/utilities/reset_app.dart';
import 'package:mastermediaplayer/services/storage_service.dart';
import 'package:mastermediaplayer/common/controllers/theme_controller.dart';
import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';

// this class will build our settings page screen
class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  final themeController = Get.find<ThemeController>();
  final storageService = Get.find<StorageService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(
              height: 25,
            ),
            NeumorphicContainer(
              padding: 5,
              child: SwitchListTile(
                activeColor: Colors.white,
                title: Text(
                  'Dark Mode',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                value: themeController.isDarkModeOn(),
                onChanged: (darkMode) {
                  if (darkMode) {
                    themeController.changeThemeMode(ThemeMode.dark);
                  } else {
                    themeController.changeThemeMode(ThemeMode.light);
                  }
                },
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.trailing,
                dense: true,
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
                    onPressed: () async {
                      await _showResetDialog(context);
                    },
                    child: const Text(
                      'Reset App',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                )),
            const Spacer(),
            _buildFooter(context),
          ],
        ),
      ),
    ));
  }

  // this method will build the footer of the settings page
  // it will contain the developer name and the version of the app
  Column _buildFooter(BuildContext context) {
    return Column(
      children: [
        Divider(
          thickness: 5,
          indent: 20,
          endIndent: 20,
          color: Theme.of(context).colorScheme.secondary,
          height: 20,
        ),
        InkWell(
            onTap: () => _copyEmailToClipboard(context),
            onLongPress: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Developed by Ibrahim Selman')));
            },
            child: const Text.rich(
              TextSpan(
                style: TextStyle(color: Colors.blue, fontSize: 18),
                children: [
                  TextSpan(
                      text: 'Developed by ', style: TextStyle(fontSize: 30)),
                  TextSpan(
                    text: 'IBS',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            )),
        const Text('version 1.3.0'),
        Divider(
          thickness: 5, // thickness of the line
          indent: 20, // empty space to the leading edge of divider.
          endIndent: 20, // empty space to the trailing edge of the divider.
          color: Theme.of(context)
              .colorScheme
              .secondary, // The color to use when painting the line.
          height: 20, // The divider's height extent.
        ),
      ],
    );
  }

  // this method will show a dialog to confirm the reset action
  Future<dynamic> _showResetDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are You Sure You Want To Reset The App?',
                textAlign: TextAlign.center),
            content: const Text(
                '\nResetting will erase all the saved Playlists, Favorite Musics and app theme-mode.'),
            actions: [
              TextButton(
                  onPressed: () async {
                    // To cancel all previous routes and going back to home
                    Get.offAllNamed('/');
                    await resetApp();
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
  }

  Row _buildHeader(BuildContext context) {
    return Row(
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
    );
  }

  // this method will copy the email to the clipboard
  void _copyEmailToClipboard(BuildContext context) {
    const email = 'contact@ibrahimselman.com';

    Clipboard.setData(const ClipboardData(text: email)).then((_) {
      // Show snackbar to  notify the user that the email is copied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email copied to clipboard')),
      );
    });
  }
}
