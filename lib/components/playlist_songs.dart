import 'package:flutter/material.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';

import '../models/playlist_model.dart';

class PlaylistSongs extends StatelessWidget {
  const PlaylistSongs({
    Key? key,
    required this.myPlaylist,
  }) : super(key: key);

  final Playlist myPlaylist;

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      padding: 10,
      // margin: 5,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: myPlaylist.songs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${index + 1}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              myPlaylist.songs[index].title,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              myPlaylist.songs[index].description,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.more_vert)),
                    ],
                  ),
                  const Divider(
                    height: 5,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
