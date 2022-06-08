import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String? _email;
  String? _username;
  String? _id;

  User(this._id, this._email, this._username);

  String? get username {
    return _username;
  }

  String? get id {
    return _id;
  }

  set id(String? id) {
    _id = id;
  }

  Future fetchData() async {
    var query = FirebaseFirestore.instance.collection('users').doc(_id);

    var snapshot = await query.get();

    var data = snapshot.data()!;

    _email = data['email'];
    _username = data['username'];
  }
}
