import 'package:flutter/material.dart';

import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';

// this class will build our custom app bar
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // menu and back button
        SizedBox(
          height: 60,
          width: 60,
          child: NeumorphicContainer(
            child: TextButton(
              onPressed: () {},
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 18,
              ),
            ),
          ),
        ),
        Text(title),
        SizedBox(
          height: 60,
          width: 60,
          child: NeumorphicContainer(
            child: TextButton(
              onPressed: () {},
              child: const Icon(Icons.menu_rounded),
            ),
          ),
        ),
      ],
    );
    //   Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     // menu and back button
    //     SizedBox(
    //       height: 60,
    //       width: 60,
    //       child: NeumorphicContainer(
    //         child: TextButton(
    //           onPressed: () {},
    //           child: const Icon(
    //             Icons.grid_view_rounded,
    //           ),
    //         ),
    //       ),
    //     ),
    //     const Text("PLAYLIST"),
    //     SizedBox(
    //       height: 60,
    //       width: 60,
    //       child: NeumorphicContainer(
    //         child: TextButton(
    //           onPressed: () {},
    //           child: const Icon(
    //             Icons.play_circle_fill,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
