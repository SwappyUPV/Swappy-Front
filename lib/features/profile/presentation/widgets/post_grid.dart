// post_grid.dart
import 'package:flutter/material.dart';

class PostGrid extends StatelessWidget {
  const PostGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: 21,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey[300],
          child: Center(child: Text('Post ${index + 1}')),
        );
      },
    );
  }
}
