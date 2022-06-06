import 'package:flutter/material.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150x150'),
                ),
              ),
              Text('Username')
            ],
          ),
          Center(
            child: Image(
                image: NetworkImage('https://via.placeholder.com/150x150')),
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.favorite_outline)),
              IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
              IconButton(onPressed: () {}, icon: Icon(Icons.send)),
              IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_outline)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('3 likes'),
              Text('UserID1 This is caption'),
              Text('View all 0 comment'),
              Text(
                DateTime.now().toIso8601String(),
              )
            ],
          )
        ],
      ),
    );
  }
}
