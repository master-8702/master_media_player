import 'package:flutter/material.dart';
import 'package:mastermediaplayer/components/neumorphic_container.dart';

class MusicSearchBar extends StatelessWidget {
  const MusicSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      padding: 10,
      margin: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Enjoy Your Favorite",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 25,
          ),
          NeumorphicContainer(
            padding: 5,
            child: TextFormField(
              decoration: InputDecoration(
                filled: true,
                hintText: 'Search',
                isDense: true,
                fillColor: Colors.lightBlue[100],
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
              ),
            ),
          )
        ],
      ),
    );
  }
}
