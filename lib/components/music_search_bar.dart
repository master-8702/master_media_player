import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';

class MusicSearchBar extends StatelessWidget {
  const MusicSearchBar({
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
          Text(
            "Welcome",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Enjoy Your Musics",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
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
                children: const [
                  Icon(Icons.search),
                  SizedBox(
                    width: 25,
                  ),
                  Text('search your playlists')
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
