
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mastermediaplayer/common/widgets/neumorphic_container.dart';

class FavoritesHeader extends StatelessWidget {
  const FavoritesHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: NeumorphicContainer(
            child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_rounded,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        Expanded(
          child: Text("My Favorites",
              style: Theme.of(context).textTheme.headlineSmall),
        ),
      ],
    );
  }
}
