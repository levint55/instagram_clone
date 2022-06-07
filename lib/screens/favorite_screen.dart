import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/home_screen/post_list.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      margin: const EdgeInsets.all(10),
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 150),
      height: double.infinity,
      child: const PostList(favoriteOnly: true),
    ));
  }
}
