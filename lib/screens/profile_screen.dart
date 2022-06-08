import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/providers/favorite_posts.dart';
import 'package:instagram_clone/providers/following.dart';
import 'package:instagram_clone/providers/posts.dart';
import 'package:instagram_clone/providers/user.dart' as instagram_user;
import 'package:instagram_clone/screens/post_detail_screen.dart';
import 'package:instagram_clone/widgets/profile_screen/profile_header_item.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future loadData(BuildContext context) async {
    final user = Provider.of<instagram_user.User>(context, listen: false);
    final FavoritePosts favoritePosts = Provider.of<FavoritePosts>(context, listen: false);
    await favoritePosts.fetchData();
    await Provider.of<Posts>(context, listen: false)
        .fetchData(favoritePosts.items, false, user.id!);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<instagram_user.User>(context, listen: false);
    final currentLoggedInUser = FirebaseAuth.instance.currentUser!;

    debugPrint('Render -> Profile screen');
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [const CircleAvatar(), Text(user.username!)],
                ),
                Consumer<Posts>(
                    builder: (context, value, child) =>
                        ProfileHeaderItem(text: 'Posts', number: value.items.length.toString())),
                const ProfileHeaderItem(text: 'Followers', number: '0'),
                const ProfileHeaderItem(text: 'Following', number: '0'),
              ],
            ),
          ),
          if (currentLoggedInUser.uid != user.id)
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                        onPressed: () {
                          Provider.of<Following>(context, listen: false).userId =
                              currentLoggedInUser.uid;
                          Provider.of<Following>(context, listen: false).addData(user);
                        },
                        child: const Text('Follow')),
                  )),
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(onPressed: () {}, child: const Text('Message')),
                  ))
                ],
              ),
            ),
          const Divider(
            thickness: 1,
            height: 20,
          ),
          FutureBuilder(
            future: loadData(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Consumer<Posts>(
                builder: (context, value, child) => GridView.builder(
                  shrinkWrap: true,
                  itemCount: value.items.length,
                  physics: const ScrollPhysics(),
                  padding: const EdgeInsets.all(5),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        Post item = value.items[index];
                        Provider.of<Post>(context, listen: false)
                            .setData(
                              item.id,
                              item.authorId,
                              item.authorUsername,
                              item.caption,
                              item.createdAt,
                              item.imageUrl,
                              item.isFavorite,
                              item.likes,
                            )
                            .then((value) =>
                                Navigator.of(context).pushNamed(PostDetailScreen.routeName));
                      },
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Image(
                          image: NetworkImage(value.items[index].imageUrl!),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
