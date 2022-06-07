import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';

class PostItem extends StatelessWidget {
  final Post post;
  const PostItem({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const CircleAvatar(
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/50x50'),
              ),
            ),
            Text(post.authorUsername!)
          ],
        ),
        Center(
          child: Image(image: NetworkImage(post.imageUrl!)),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  // Provider.of<FavoritePosts>(context, listen: false)
                  //       .switchFavorite(context, widget.post.id!)
                  //       .then((value) => setState(() {
                  //             _isFavorite =
                  //                 Provider.of<Post>(context, listen: false)
                  //                     .isFavorite!;
                  //             _likes = Provider.of<Post>(context, listen: false)
                  //                 .likes!;
                  //           }));
                },
                icon: Icon(post.isFavorite!
                    ? Icons.favorite
                    : Icons.favorite_outline)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.comment)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.bookmark_outline)),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${post.likes} likes'),
              Text(post.caption!),
              const Text('View all 0 comment'),
              Text(post.createdAt!.toDate().toString())
            ],
          ),
        )
      ],
    );
  }
}
