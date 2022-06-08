import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user.dart';

class Following with ChangeNotifier {
  List<User> followers = [];
  String userId = '';

  Future fetchData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('relations/$userId/following').get();

    List<User> newFollowers = snapshot.docs.map((e) {
      var data = e.data();
      return User(data['id'], data['email'], data['username']);
    }).toList();

    followers = newFollowers;

    notifyListeners();
  }

  Future addData(User otherUser) async {
    var newUser = {
      'email': otherUser.email,
      'username': otherUser.username,
    };
    await FirebaseFirestore.instance
        .collection('relations/$userId/following')
        .doc(otherUser.id)
        .set(newUser);

    followers.add(otherUser);

    notifyListeners();
  }
}
