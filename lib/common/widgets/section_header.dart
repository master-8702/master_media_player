import 'package:flutter/material.dart';

// section header widget for the home screen
class SectionHeader extends StatelessWidget {
  final String title;
  final String action;

  const SectionHeader({
    Key? key,
    required this.title,
    this.action = "View all",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        Text(action, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
