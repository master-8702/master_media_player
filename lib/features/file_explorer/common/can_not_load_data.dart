import 'package:flutter/material.dart';

class CanNotLoadData extends StatelessWidget {
  /// This custom widget will be used whenever an error ocurred while fetching data
  /// to display 'can not load data' text.

  const CanNotLoadData({super.key, required this.message});
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
