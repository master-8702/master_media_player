import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/components/utilities/utilities.dart';

class MusicExplorer3 extends StatefulWidget {
  const MusicExplorer3({Key? key}) : super(key: key);

  @override
  State<MusicExplorer3> createState() => _MusicExplorerState3();
}

class _MusicExplorerState3 extends State<MusicExplorer3> {
  ValueNotifier<Directory> currentDirectory = ValueNotifier(Directory(''));
  ValueNotifier<Directory> rootDirectory = ValueNotifier(Directory(''));
  ValueNotifier<List<Directory>> storageList = ValueNotifier([]);
  ValueNotifier<Directory> selectedStorage = ValueNotifier(Directory(''));
  List<String> supportedFormats = [
    'jpg',
    'jpeg',
    'png',
  ];

  @override
  void initState() {
    Utilities.getStorageList().then((value) {
      currentDirectory.value = value[0];
      rootDirectory.value = value[0];
      storageList.value = value;
    });
    // currentDirectory.value = storageList[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: ValueListenableBuilder(
                valueListenable: currentDirectory,
                builder: (context, currentDir, child) {
                  return Text(Utilities.basename(currentDir) != '0'
                      ? Utilities.basename(currentDir)
                      : 'Local Storage');
                }),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
              IconButton(
                  onPressed: () => selectStorage(),
                  icon: const Icon(Icons.sd_storage)),
            ]),
        body: ValueListenableBuilder<Directory>(
            valueListenable: currentDirectory,
            builder: (context, currentDir, child) {
              return FutureBuilder<List<FileSystemEntity>>(
                  future: currentDir.list().toList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<FileSystemEntity> allFiles =
                          snapshot.data as List<FileSystemEntity>;
                      allFiles = allFiles.where((element) {
                        if (Utilities.basename(element).startsWith('.') ||
                            (Utilities.basename(element) == "") ||
                            (element is File &&
                                !supportedFormats.contains(
                                    Utilities.getFileExtension(element)))) {
                          return false;
                        } else {
                          return true;
                        }
                      }).toList();

                      if (allFiles.isEmpty) {
                        return const Center(
                          heightFactor: 5,
                          child: Text(
                            'No Image Files in This Folder',
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }
                      // making list of only files
                      final dirs = allFiles!.whereType<Directory>().toList();
                      // sorting folder list by name.
                      dirs.sort((a, b) =>
                          a.path.toLowerCase().compareTo(b.path.toLowerCase()));

                      // making list of only flies.
                      List<File> files = allFiles!.whereType<File>().toList();

                      // sorting files list by name.
                      files.sort((a, b) =>
                          a.path.toLowerCase().compareTo(b.path.toLowerCase()));

                      // first folders will go to list (if available) then files will go to list.
                      List<FileSystemEntity> organizedFiles = [
                        ...dirs,
                        ...files
                      ];

                      return ListView.builder(
                          itemCount: organizedFiles.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                  leading: organizedFiles[index] is File
                                      ? SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Image.file(
                                              cacheHeight: 100,
                                              cacheWidth: 100,
                                              organizedFiles[index] as File),
                                        )
                                      : const Icon(Icons.folder),
                                  title: Text(
                                      Utilities.basename(organizedFiles[index]),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  onTap: () async {
                                    if (organizedFiles[index] is Directory) {
                                      currentDirectory.value =
                                          organizedFiles[index] as Directory;
                                    } else {
                                      Get.back(
                                          result: organizedFiles[index].path);
                                    }
                                  }),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Column(
                        children: const [
                          CircularProgressIndicator(),
                          Center(child: Text('Can Not Load Data!')),
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
        floatingActionButton: NeumorphicContainer(
          padding: 2,
          margin: 10,
          child: IconButton(
            onPressed: () {
              if (currentDirectory.value.path != rootDirectory.value.path) {
                currentDirectory.value = currentDirectory.value.parent;
              } else {
                Get.snackbar('This is the root Directory', 'Can not go back!');
              }
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 35,
            ),
          ),
        ),
      ),
    );
  }

  void selectStorage() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: FutureBuilder<List<Directory>>(
          future: Utilities.getStorageList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<FileSystemEntity> storageList = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: storageList
                        .map((e) => ListTile(
                              title: Text(
                                Utilities.basename(e),
                              ),
                              onTap: () {
                                currentDirectory.value = e as Directory;
                                Get.back();
                              },
                            ))
                        .toList()),
              );
            }
            return const Dialog(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}