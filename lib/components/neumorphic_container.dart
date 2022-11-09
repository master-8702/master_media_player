import 'package:flutter/material.dart';

class NeumorphicContainer extends StatelessWidget {
  final child;
  final double padding;
  final double margin;
  const NeumorphicContainer({
    Key? key,
    required this.child,
    this.padding = 0,
    this.margin = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.all(margin),
      child: child,
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            //darker shadow on the bottom right
            BoxShadow(
              color: Colors.grey.shade500,
              blurRadius: 15,
              offset: const Offset(5, 5),
            ),
            // lighter shadow on the top left
            const BoxShadow(
              color: Colors.white,
              blurRadius: 15,
              offset: Offset(-5, -5),
            ),
          ]),
    );
  }
}
