import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mastermediaplayer/common/controllers/timerController.dart';
import 'package:mastermediaplayer/utilities/format_duration.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({
    super.key,
    required this.timerController,
  });

  final TimerController timerController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() {
          if (timerController.duration.value > Duration.zero) {
            return Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    topRight: Radius.circular(12)),
                color: Theme.of(context).dialogBackgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '⏱ ${formatDuration(timerController.duration.value)}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            );
          } else {
            return const Text('');
          }
        }),
      ],
    );
  }
}
