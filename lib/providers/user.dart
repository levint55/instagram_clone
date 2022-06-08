import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String? email;
  String? username;
  String? id;

  User(this.id, this.email, this.username);

  Future fetchData() async {
    var query = FirebaseFirestore.instance.collection('users').doc(id);

    var snapshot = await query.get();

    var data = snapshot.data()!;

    email = data['email'];
    username = data['username'];
  }
}
