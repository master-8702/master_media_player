import 'package:flutter/material.dart';

// This stateless widget will be displayed when there is no any search result 
// displaying a no search result with a little funny emoji.  
class NoSearchResult extends StatelessWidget {
  const NoSearchResult({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'I don\'t know any music or playlist\n  by that name!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
        Flexible(
            child: Image.asset(
                height: 150,
                width: 150,
                'assets/images/you_are_not_drunk.png')),
        const SizedBox(
          height: 15,
        ),
        const Text(
          'You are not drunk, right?',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
