import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
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
    Provider.of<Post>(context, listen: false).id = id;

    await Provider.of<Post>(context, listen: false).fetchData();

    if (_items.containsKey(id)) {
      _items[id] = !_items[id]!;
      await query.update({'isFavorite': _items[id]});
      Provider.of<Post>(context, listen: false).isFavorite = _items[id];
      if (_items[id]!) {
        await Provider.of<Post>(context, listen: false).incrementFavorite();
      } else {
        await Provider.of<Post>(context, listen: false).decrementFavorite();
      }
    } else {
      _items[id] = true;
      await query.set({'isFavorite': _items[id]});
      Provider.of<Post>(context, listen: false).isFavorite = _items[id];
      await Provider.of<Post>(context, listen: false).incrementFavorite();
    }

    notifyListeners();
  }
}
