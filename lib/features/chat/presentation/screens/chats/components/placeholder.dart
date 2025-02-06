import 'package:flutter/material.dart';
import '../../../../constants.dart';

/// This widget is used as a placeholder for displaying loading UI when
/// user data (such as profile picture, name, and messages) is not yet
/// available or is being loaded.
///
/// It shows a greyed-out version of the content, such as a grey circle
/// for the profile image, grey boxes for the name and message, and a
/// faded "..." text to indicate that the content is loading.
class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding * 0.75,
      ),
      child: Row(
        children: [
          // Grey Circle Avatar for placeholder
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grey placeholder for name
                  Container(
                    height: 16,
                    width: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  // Grey placeholder for message
                  Container(
                    height: 14,
                    width: 150,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          // Faded "..." text to indicate loading
          const Opacity(
            opacity: 0.64,
            child: Text("..."),
          ),
        ],
      ),
    );
  }
}
