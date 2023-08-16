import 'package:flutter/material.dart';

class NoFilesInThisFolder extends StatelessWidget {
  /// This custom widget will be used for displaying 'No files found', when there is no
  /// matching file in the given directory.

  const NoFilesInThisFolder({
    super.key,
    required this.message,
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/who cares emoji.png'),
        const SizedBox(
          height: 15,
        ),
        Text(message, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
