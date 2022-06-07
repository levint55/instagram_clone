import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post with ChangeNotifier {
  String? id;
  String? authorId;
  String? authorUsername;
  String? caption;
  Timestamp? createdAt;
  String? imageUrl;
  bool? isFavorite;
  int? likes;

  Post(this.id, this.authorId, this.authorUsername, this.caption,
      this.createdAt, this.imageUrl, this.isFavorite, this.likes);

  Future setData(
      String? id,
      String? authorId,
      String? authorUsername,
      String? caption,
      Timestamp? createdAt,
      String? imageUrl,
      bool? isFavorite,
      int? likes) async {
    this.id = id;
    this.authorId = authorId;
    this.authorUsername = authorUsername;
    this.caption = caption;
    this.createdAt = createdAt;
    this.imageUrl = imageUrl;
    this.isFavorite = isFavorite;
    this.likes = likes;
  }

  Future fetchData() async {
    final query = FirebaseFirestore.instance.collection('posts').doc(id);
    var snapshot = await query.get();
    var data = snapshot.data()!;

    id = snapshot.id;
    authorId = data['authorId'];
    authorUsername = data['authorUsername'];
    caption = data['caption'];
    createdAt = data['createdAt'];
    imageUrl = data['imageUrl'];
    isFavorite = data['isFavorite'];
    likes = data['likes'];

    notifyListeners();
  }

  Future incrementFavorite() async {
    final query = FirebaseFirestore.instance.collection('posts').doc(id);
    likes = likes! + 1;
    await query.update({'likes': likes});
  }

  Future decrementFavorite() async {
    final query = FirebaseFirestore.instance.collection('posts').doc(id);
    likes = likes! - 1;
    await query.update({'likes': likes});
  }
}
