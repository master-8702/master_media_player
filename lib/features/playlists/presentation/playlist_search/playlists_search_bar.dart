import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';
import 'package:mastermediaplayer/utilities/utilities.dart';

class PlaylistSearchBar extends StatelessWidget {
  const PlaylistSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      padding: 10,
      margin: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Enjoy Your Musics",
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              NeumorphicContainer(
                child: TextButton(
                  onPressed: () async {
                    Utilities().requestPermission();

                    Get.toNamed('fileExplorer');
                  },
                  child: const Icon(
                    Icons.folder,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 25,
          ),
          NeumorphicContainer(
            padding: 5,
            child: TextButton(
              onPressed: () {
                Get.toNamed('search');
              },
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(
                    width: 25,
                  ),
                  Text(
                    'search your playlists',
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ),
            ),
          )
          // this music player app is developed by master
        ],
      ),
    );
  }
}
