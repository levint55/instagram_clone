import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';

class Posts with ChangeNotifier {
  List<Post> _items = [];

  List<Post> get items {
    return _items;
  }

  Future fetchData(Map<String, bool> favoritePosts) async {
    // final user = FirebaseAuth.instance.currentUser;
    var query = FirebaseFirestore.instance.collection('posts');

    final snapshot = await query.get();

    List<Post> newItems = snapshot.docs.map((e) {
      var data = e.data();
      if (favoritePosts.containsKey(e.id)) {
        return Post(e.id, data['authorId'], data['caption'], data['createdAt'],
            data['imageUrl'], favoritePosts[e.id]!);
      }
      return Post(e.id, data['authorId'], data['caption'], data['createdAt'],
          data['imageUrl'], false);
    }).toList();

    _items = newItems;

    notifyListeners();
  }

  Future addData(String caption, File pickedImage) async {
    final user = FirebaseAuth.instance.currentUser;
    final timestamp = Timestamp.now();

    //Add post
    final ref = await FirebaseFirestore.instance.collection('posts').add(
        {'caption': caption, 'createdAt': timestamp, 'authorId': user?.uid});

    final imgRef =
        FirebaseStorage.instance.ref().child('posts').child(ref.id + '.jpg');

    //Put image to firebase storage
    await imgRef.putFile(pickedImage);

    final url = await imgRef.getDownloadURL();

    //Set image url
    await ref.update({
      'imageUrl': url,
    });

    Post newPost = Post(ref.id, user!.uid, caption, timestamp, url, false);

    _items.add(newPost);

    notifyListeners();
  }
}
