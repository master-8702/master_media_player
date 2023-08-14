import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';
import 'package:text_scroll/text_scroll.dart';

/// This class will be removed after refactoring is complete

// this class is going to help us in basic file(Picture) exploring from the available storage devices in the phone
// and it will be used to select singe image file from the storage in order to assign it as a cover image for our playlists.
// it will also allow us to preview the images without opening them (as a prefix icon in the listTie)
class MusicExplorer3 extends StatefulWidget {
  const MusicExplorer3({Key? key}) : super(key: key);

  @override
  State<MusicExplorer3> createState() => _MusicExplorerState3();
}

class _MusicExplorerState3 extends State<MusicExplorer3> {
  // here we will declare the following change notifier variables in order to update our UI
  // base on the new changes
  ValueNotifier<Directory> currentDirectory = ValueNotifier(Directory(''));
  ValueNotifier<Directory> rootDirectory = ValueNotifier(Directory(''));
  ValueNotifier<List<Directory>> storageList = ValueNotifier([]);
  ValueNotifier<Directory> selectedStorage = ValueNotifier(Directory(''));
  List<String> supportedFormats = [
    'jpg',
    'jpeg',
    'png',
  ];

  List<FileSystemEntity> _organizedFiles = [];
  final ValueNotifier<List<FileSystemEntity>> _foundFiles = ValueNotifier([]);
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // here we will ask permission in case it is not already given while starting the app
    Utilities().requestPermission();

    // and here we will initialize currentDirectory and current Storage list by using Future Values
    Utilities.getStorageList().then((value) {
      currentDirectory.value = value[0];
      rootDirectory.value = value[0];
      storageList.value = value;
    });
    // currentDirectory.value = storageList[0];

    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          // here by using willPopScope widget we will override the back button
          // and while pressing back if we didn't reach the root folder we will block the back button handler from
          // popping the page from the stack  by returning "Future false"
          // but if we reach the root folder we will allow the handler to pop the page and take us back to the
          // previous page by returning "Future true";

          if (currentDirectory.value.path != rootDirectory.value.path) {
            currentDirectory.value = currentDirectory.value.parent;
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // menu and back button
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
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),

                      // here by listening to the changes from currentDirectory value notifier
                      // we will update the current Directory or folder name in the title of the page
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: currentDirectory,
                            builder: (context, currentDir, child) {
                              return TextScroll(
                                velocity: const Velocity(
                                    pixelsPerSecond: Offset(30, 30)),
                                Utilities.basename(currentDir) != '0'
                                    ? Utilities.basename(currentDir)
                                    : 'Local Storage',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(fontSize: 20),
                              );
                            }),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: NeumorphicContainer(
                          child: TextButton(
                            onPressed: () {
                              selectStorage();
                            },
                            child: const Icon(
                              Icons.sd_storage,
                            ),
                          ),
                        ),
                      ),
                    ]),
                const SizedBox(
                  height: 15,
                ),
                // here we will have a search TextField to be able to search the current folder
                NeumorphicContainer(
                  padding: 10,
                  child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Search Current Folder',
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (enteredValue) {
                      // here on every key stoke we will search (filter) the list and return found musics(files) or the result
                      List<FileSystemEntity> searchResult = [];
                      if (enteredValue.isEmpty) {
                        searchResult = _organizedFiles;
                      } else {
                        searchResult = _organizedFiles
                            .where((file) =>
                                Utilities.basename(file).toLowerCase().contains(
                                      enteredValue.toLowerCase(),
                                    ))
                            .toList();
                      }

                      _foundFiles.value = searchResult;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // here by listening to the changes from currentDirectory value notifier we will make a new list of
                // files and folder from the selected folder and update the UI accordingly
                Expanded(
                  child: ValueListenableBuilder<Directory>(
                      valueListenable: currentDirectory,
                      builder: (context, currentDir, child) {
                        // here we will clear the search text field when the user opens a new (another) folder
                        textEditingController.text = '';
                        return FutureBuilder<List<FileSystemEntity>>(
                            future: currentDir.list().toList(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<FileSystemEntity> allFiles =
                                    snapshot.data as List<FileSystemEntity>;
                                allFiles = allFiles.where((element) {
                                  if (Utilities.basename(element)
                                          .startsWith('.') ||
                                      (Utilities.basename(element) == "") ||
                                      (element is File &&
                                          !supportedFormats.contains(
                                              Utilities.getFileExtension(
                                                  element)))) {
                                    return false;
                                  } else {
                                    return true;
                                  }
                                }).toList();

                                if (allFiles.isEmpty) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                          'assets/images/who cares emoji.png'),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Text(
                                        'No Image Files in This Folder',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  );
                                }
                                // making list of only files
                                final dirs =
                                    allFiles.whereType<Directory>().toList();
                                // sorting folder list by name.
                                dirs.sort((a, b) => a.path
                                    .toLowerCase()
                                    .compareTo(b.path.toLowerCase()));

                                // making list of only flies.
                                List<File> files =
                                    allFiles.whereType<File>().toList();

                                // sorting files list by name.
                                files.sort((a, b) => a.path
                                    .toLowerCase()
                                    .compareTo(b.path.toLowerCase()));

                                // first folders will go to list (if available) then files will go to list.
                                _organizedFiles = [...dirs, ...files];
                                _foundFiles.value = List.from(_organizedFiles);

                                // and here by listening to the _foundFiles value notifier (if the change query changes)
                                // we will update the list based on the search result and Update the UI as well
                                return ValueListenableBuilder<
                                        List<FileSystemEntity>>(
                                    valueListenable: _foundFiles,
                                    builder: (context, foundFiles, child) {
                                      return ListView.builder(
                                          itemCount: foundFiles.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              child: ListTile(
                                                  leading: foundFiles[index]
                                                          is File
                                                      ? SizedBox(
                                                          width: 100,
                                                          height: 100,
                                                          child: Image.file(
                                                              cacheHeight: 100,
                                                              cacheWidth: 100,
                                                              foundFiles[index]
                                                                  as File),
                                                        )
                                                      : const Icon(
                                                          Icons.folder),
                                                  title: Text(
                                                      Utilities.basename(
                                                          foundFiles[index]),
                                                      maxLines: 2,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  onTap: () async {
                                                    if (foundFiles[index]
                                                        is Directory) {
                                                      currentDirectory.value =
                                                          foundFiles[index]
                                                              as Directory;
                                                    } else {
                                                      Get.back(
                                                          result:
                                                              foundFiles[index]
                                                                  .path);
                                                    }
                                                  }),
                                            );
                                          });
                                    });
                              } else if (snapshot.hasError) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                        'assets/images/who cares emoji.png'),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                      'Can Not Load Data!',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: const [
                                    CircularProgressIndicator(),
                                    Center(child: Text('Loading Data ...')),
                                  ],
                                );
                              }
                            });
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // this method will show us a dialog with a list of available storage devices (memories) in the device
  // and by selecting one we can update the current Directory List and surf the new selected storage devices
  void selectStorage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[300],
        content: FutureBuilder<List<Directory>>(
          future: Utilities.getStorageList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<FileSystemEntity> storageList = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: storageList
                        .map((e) => Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    child: TextButton(
                                      child: Text(
                                        Utilities.basename(e),
                                      ),
                                      onPressed: () {
                                        currentDirectory.value = e as Directory;
                                        Get.back();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ))
                        .toList()),
              );
            }
            return const AlertDialog(
              // this music player app is developed by master
              content: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
