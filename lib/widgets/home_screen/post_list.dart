import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/favorite_posts.dart';
import 'package:instagram_clone/providers/posts.dart';
import 'package:instagram_clone/widgets/home_screen/post_list_item.dart';
import 'package:provider/provider.dart';

class PostList extends StatelessWidget {
  final bool favoriteOnly;

  const PostList({Key? key, required this.favoriteOnly}) : super(key: key);

  Future loadData(BuildContext context) async {
    final FavoritePosts favoritePosts =
        Provider.of<FavoritePosts>(context, listen: false);
    await favoritePosts.fetchData();
    await Provider.of<Posts>(context, listen: false)
        .fetchData(favoritePosts.items, favoriteOnly);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Render -> Post list');
    return FutureBuilder(
        future: loadData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Consumer<Posts>(
            builder: (context, value, child) => ListView.builder(
              itemCount: value.items.length,
              itemBuilder: (context, index) =>
                  PostListItem(post: value.items[index]),
            ),
          );
        });
  }
}
