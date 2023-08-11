import 'package:flutter/material.dart';

class LoadingData extends StatelessWidget {
  /// This custom widget will be used for displaying progress indicator while fetching
  /// data is in progress.

  const LoadingData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const CircularProgressIndicator(),
      Center(
          child: Text('Loading Data ...',
              style: Theme.of(context).textTheme.titleLarge)),
    ]);
  }
}
