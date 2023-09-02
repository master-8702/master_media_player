import 'package:flutter/material.dart';
import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';

class PlayOrShuffleSwitch extends StatefulWidget {
  const PlayOrShuffleSwitch({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayOrShuffleSwitch> createState() => _PlayOrShuffleSwitchState();
}

class _PlayOrShuffleSwitchState extends State<PlayOrShuffleSwitch> {
  bool isPlay = true;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        setState(() {
          isPlay = !isPlay;
        });
      },
      child: NeumorphicContainer(
        padding: 10,
        child: Container(
          height: 50,
          width: width,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: isPlay ? 0 : width * 0.4,
                child: Container(
                  height: 50,
                  width: width * 0.45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Play",
                            style: TextStyle(
                                color: isPlay ? Colors.white : Colors.blue,
                                fontSize: 24),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.play_circle,
                          color: isPlay ? Colors.white : Colors.blue,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Shuffle",
                            style: TextStyle(
                                color: isPlay ? Colors.blue : Colors.white,
                                fontSize: 24),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.shuffle,
                          color: isPlay ? Colors.blue : Colors.white,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
