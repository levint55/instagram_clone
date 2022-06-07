import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/providers/favorite_posts.dart';
import 'package:instagram_clone/providers/posts.dart';
import 'package:instagram_clone/screens/post_detail_screen.dart';
import 'package:instagram_clone/widgets/profile_screen/profile_header_item.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future loadData(BuildContext context) async {
    final FavoritePosts favoritePosts =
        Provider.of<FavoritePosts>(context, listen: false);
    await favoritePosts.fetchData();
    await Provider.of<Posts>(context, listen: false)
        .fetchData(favoritePosts.items, false, true);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Render -> Profile screen');
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [CircleAvatar(), Text('Username')],
                ),
                ProfileHeaderItem(text: 'Posts', number: '0'),
                ProfileHeaderItem(text: 'Followers', number: '0'),
                ProfileHeaderItem(text: 'Following', number: '0'),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            height: 20,
          ),
          FutureBuilder(
            future: loadData(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Consumer<Posts>(
                builder: (context, value, child) => GridView.builder(
                    shrinkWrap: true,
                    itemCount: value.items.length,
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.all(5),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.all(5),
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
                                      item.likes)
                                  .then((value) => Navigator.of(context)
                                      .pushNamed(PostDetailScreen.routeName));
                            },
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Image(
                                  image: NetworkImage(
                                      value.items[index].imageUrl!),
                                )),
                          ),
                        )),
              );
            },
          )
        ],
      ),
    );
  }
}
