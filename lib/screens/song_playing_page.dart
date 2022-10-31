import 'package:flutter/material.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';

class SongPlayingPage extends StatefulWidget {
  const SongPlayingPage({Key? key}) : super(key: key);

  @override
  State<SongPlayingPage> createState() => _SongPlayingPageState();
}

class _SongPlayingPageState extends State<SongPlayingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
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
                          onPressed: () {},
                          child: const Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    const Text("PLAYLIST"),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {},
                          child: const Icon(Icons.menu),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),

                // cover art, song name , artist name, album name
                NeumorphicContainer(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 280,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/alfu_selat.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Alfu Selat",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Fuad Al-burda",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 32,
                              shadows: [
                                BoxShadow(
                                  color: Colors.red,
                                  blurRadius: 10,
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // Spacer(),

                // start time , shuffle button, repeat button, end time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('4:08'),
                    TextButton(
                        onPressed: () {}, child: const Icon(Icons.shuffle)),
                    TextButton(
                        onPressed: () {}, child: const Icon(Icons.repeat)),
                    const Text('16:12')
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                // playing time indicator (progress bar)
                const NeumorphicContainer(
                  child: LinearProgressIndicator(
                    value: 0.3, minHeight: 8,
                    // backgroundColor: Colors.red,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                // previous song , ply/pause, next song buttons

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {},
                          child: const Icon(Icons.skip_previous, size: 22),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {},
                          child: const Icon(Icons.fast_rewind, size: 22),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 3,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {},
                          child: const Icon(
                            Icons.play_arrow,
                            size: 45,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {},
                          child: const Icon(Icons.fast_forward, size: 22),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: NeumorphicContainer(
                        child: TextButton(
                          onPressed: () {},
                          child: const Icon(Icons.skip_next, size: 22),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
