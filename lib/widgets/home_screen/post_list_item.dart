import 'package:flutter/material.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('Render -> Post list item');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: const CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150x150'),
                ),
              ),
              const Text('Username')
            ],
          ),
          const Center(
            child: Image(
                image: NetworkImage('https://via.placeholder.com/150x150')),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.favorite_outline)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.comment)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.bookmark_outline)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('3 likes'),
              const Text('UserID1 This is caption'),
              const Text('View all 0 comment'),
              Text(
                DateTime.now().toIso8601String(),
              )
            ],
          )
        ],
      ),
    );
  }
}
