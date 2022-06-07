import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CurrentUser with ChangeNotifier {
  String? _email;
  String? _username;

  CurrentUser(this._email, this._username);

  get username {
    return _username;
  }

  Future fetchData() async {
    final user = FirebaseAuth.instance.currentUser!;
    var query = FirebaseFirestore.instance.collection('users').doc(user.uid);

    var snapshot = await query.get();

    var data = snapshot.data()!;

    _email = data['email'];
    _username = data['username'];
  }
}
