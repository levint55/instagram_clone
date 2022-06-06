import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritePosts with ChangeNotifier {
  final Map<String, bool> _items = {};

  Map<String, bool> get items {
    return _items;
  }

  Future fetchData() async {
    final user = FirebaseAuth.instance.currentUser!;
    var query =
        FirebaseFirestore.instance.collection('favorites/${user.uid}/posts');

    final snapshot = await query.get();

    for (var element in snapshot.docs) {
      var data = element.data();
      _items[element.id] = data['isFavorite'];
    }

    notifyListeners();
  }

  Future switchFavorite(String id) async {
    final user = FirebaseAuth.instance.currentUser!;
    var query = FirebaseFirestore.instance
        .collection('favorites/${user.uid}/posts')
        .doc(id);

    if (_items.containsKey(id)) {
      _items[id] = !_items[id]!;
      await query.update({'isFavorite': _items[id]});
    } else {
      _items[id] = true;
      await query.set({'isFavorite': _items[id]});
    }

    notifyListeners();
  }
}
