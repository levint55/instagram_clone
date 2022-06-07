import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/providers/current_user.dart';
import 'package:provider/provider.dart';

class Posts with ChangeNotifier {
  List<Post> _items = [];

  List<Post> get items {
    return _items;
  }

  Post? getPostWithId(String id) {
    var postIndex = _items.indexWhere((element) => element.id == id);
    Post? post;

    if (postIndex >= 0) {
      post = _items.elementAt(postIndex);
    }

    return post;
  }

  Future incrementFavorite(String id) async {
    final query = FirebaseFirestore.instance.collection('posts').doc(id);
    final post = getPostWithId(id);
    post?.likes++;
    await query.update({'likes': post?.likes});
  }

  Future decrementFavorite(String id) async {
    final query = FirebaseFirestore.instance.collection('posts').doc(id);
    final post = getPostWithId(id);
    post?.likes--;
    await query.update({'likes': post?.likes});
  }

  Future fetchData(Map<String, bool> favoritePosts,
      [bool showFavoriteOnly = false]) async {
    var query = FirebaseFirestore.instance.collection('posts');

    final snapshot = await query.get();
    var docs = snapshot.docs;

    if (showFavoriteOnly) {
      docs = snapshot.docs.where((element) {
        return favoritePosts[element.id] ?? false;
      }).toList();
    }

    List<Post> newItems = docs.map((e) {
      var data = e.data();
      if (favoritePosts.containsKey(e.id)) {
        return Post(
            e.id,
            data['authorId'],
            data['authorUsername'],
            data['caption'],
            data['createdAt'],
            data['imageUrl'],
            favoritePosts[e.id]!,
            data['likes'] ?? 0);
      }
      return Post(
          e.id,
          data['authorId'],
          data['authorUsername'],
          data['caption'],
          data['createdAt'],
          data['imageUrl'],
          false,
          data['likes'] ?? 0);
    }).toList();

    _items = newItems;

    notifyListeners();
  }

  Future addData(BuildContext context, String caption, File pickedImage) async {
    final user = FirebaseAuth.instance.currentUser;
    final timestamp = Timestamp.now();
    CurrentUser currentUser = Provider.of<CurrentUser>(context, listen: false);

    //Add post
    final ref = await FirebaseFirestore.instance.collection('posts').add({
      'caption': caption,
      'createdAt': timestamp,
      'authorId': user?.uid,
      'authorUsername': currentUser.username,
      'likes': 0
    });

    final imgRef =
        FirebaseStorage.instance.ref().child('posts').child(ref.id + '.jpg');

    //Put image to firebase storage
    await imgRef.putFile(pickedImage);

    final url = await imgRef.getDownloadURL();

    //Set image url
    await ref.update({
      'imageUrl': url,
    });

    Post newPost = Post(ref.id, user!.uid, currentUser.username, caption,
        timestamp, url, false, 0);

    _items.add(newPost);

    notifyListeners();
  }
}
