import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/widgets/post/post_item.dart';
import 'package:provider/provider.dart';

class PostDetailScreen extends StatefulWidget {
  static const routeName = '/post-detail';
  const PostDetailScreen({Key? key}) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('Render -> Post detail screen');
    Post post = Provider.of<Post>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: PostItem(
          post: post,
        ),
      ),
    );
  }
}
