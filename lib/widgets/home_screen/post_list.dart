import 'package:flutter/material.dart';
import 'package:instagram_clone/dummy.dart';
import 'package:instagram_clone/widgets/home_screen/post_list_item.dart';

class PostList extends StatelessWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dummyData.length,
      itemBuilder: (context, index) => PostListItem(),
    );
  }
}
