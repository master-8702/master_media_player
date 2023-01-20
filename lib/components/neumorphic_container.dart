import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
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
    bool isDarkModeOn = GetStorage().read('isDarkModeOn') ?? false;
    return Container(
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isDarkModeOn
              ? [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    blurRadius: 1,
                    offset: const Offset(2, 2),
                  ),
                  // lighter shadow on the top left
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 1,
                    offset: Offset(-2, -2),
                  ),
                ]
              : [
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
      child: child,
    );
  }
}
