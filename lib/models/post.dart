import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String authorId;
  final String caption;
  final Timestamp createdAt;
  final String imageUrl;
  bool isFavorite;

  Post(this.id, this.authorId, this.caption, this.createdAt, this.imageUrl,
      this.isFavorite);
}
