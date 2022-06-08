import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/favorite_posts.dart';
import 'package:instagram_clone/providers/posts.dart';
import 'package:instagram_clone/providers/user.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  static const routeName = '/user-profile-screen';
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () async {
                Provider.of<User>(context, listen: false).id = '';
                final FavoritePosts favoritePosts =
                    Provider.of<FavoritePosts>(context, listen: false);
                await favoritePosts.fetchData();
                await Provider.of<Posts>(context, listen: false).fetchData(favoritePosts.items);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back))),
      body: const ProfileScreen(),
    );
  }
}
