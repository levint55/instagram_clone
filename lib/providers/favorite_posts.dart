import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/posts.dart';
import 'package:provider/provider.dart';

class FavoritePosts with ChangeNotifier {
  Map<String, bool> _items = {};

  Map<String, bool> get items {
    return _items;
  }

  Future fetchData() async {
    _items = {};
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

  Future switchFavorite(BuildContext context, String id) async {
    final user = FirebaseAuth.instance.currentUser!;
    var query = FirebaseFirestore.instance
        .collection('favorites/${user.uid}/posts')
        .doc(id);

    if (_items.containsKey(id)) {
      _items[id] = !_items[id]!;
      await query.update({'isFavorite': _items[id]});
      if (_items[id]!) {
        await Provider.of<Posts>(context, listen: false).incrementFavorite(id);
      } else {
        await Provider.of<Posts>(context, listen: false).decrementFavorite(id);
      }
    } else {
      _items[id] = true;
      await query.set({'isFavorite': _items[id]});
      await Provider.of<Posts>(context, listen: false).incrementFavorite(id);
    }

    notifyListeners();
  }
}
