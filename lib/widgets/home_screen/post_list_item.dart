import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/providers/favorite_posts.dart';
import 'package:provider/provider.dart';

class PostListItem extends StatefulWidget {
  final Post post;

  const PostListItem({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostListItem> createState() => _PostListItemState();
}

class _PostListItemState extends State<PostListItem> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.post.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Render -> Post list item');
    return Container(
      key: ValueKey(widget.post.id),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              const Text('Username')
            ],
          ),
          Center(
            child: Image(image: NetworkImage(widget.post.imageUrl)),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Provider.of<FavoritePosts>(context, listen: false)
                        .switchFavorite(widget.post.id);
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                  icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_outline)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.comment)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.bookmark_outline)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('3 likes'),
              Text(widget.post.caption),
              const Text('View all 0 comment'),
              Text(widget.post.createdAt.toDate().toString())
            ],
          )
        ],
      ),
    );
  }
}
