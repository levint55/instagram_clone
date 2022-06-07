import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/widgets/post/post_item.dart';

class PostListItem extends StatelessWidget {
  final Post post;

  const PostListItem({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('Render -> Post list item');
    return Container(
      key: ValueKey(post.id),
      margin: const EdgeInsets.only(bottom: 10),
      child: PostItem(post: post),
    );
  }
}
