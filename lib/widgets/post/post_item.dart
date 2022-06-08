import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/providers/favorite_posts.dart';
import 'package:instagram_clone/providers/user.dart';
import 'package:instagram_clone/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';

class PostItem extends StatefulWidget {
  final Post post;
  const PostItem({Key? key, required this.post}) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late bool? _isFavorite;
  late int? _likes;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.post.isFavorite;
    _likes = widget.post.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const CircleAvatar(
                backgroundImage: NetworkImage('https://via.placeholder.com/50x50'),
              ),
            ),
            InkWell(
              child: Text(widget.post.authorUsername!),
              onTap: () async {
                final user = Provider.of<User>(context, listen: false);
                user.id = widget.post.authorId;
                await user.fetchData();
                Navigator.of(context).pushNamed(UserProfileScreen.routeName);
              },
            )
          ],
        ),
        Center(
          child: Image(image: NetworkImage(widget.post.imageUrl!)),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Provider.of<FavoritePosts>(context, listen: false)
                      .switchFavorite(context, widget.post.id!)
                      .then((value) => setState(() {
                            _isFavorite = Provider.of<Post>(context, listen: false).isFavorite!;
                            _likes = Provider.of<Post>(context, listen: false).likes!;
                          }));
                },
                icon: Icon(_isFavorite! ? Icons.favorite : Icons.favorite_outline)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.comment)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_outline)),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$_likes likes'),
              Text(widget.post.caption!),
              const Text('View all 0 comment'),
              Text(widget.post.createdAt!.toDate().toString())
            ],
          ),
        )
      ],
    );
  }
}
