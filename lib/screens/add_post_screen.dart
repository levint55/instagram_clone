import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/add_post_screen/add_post_form.dart';

class AddPostScreen extends StatelessWidget {
  static const routeName = '/add-post';
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('Render -> Add post screen');
    return const SingleChildScrollView(child: AddPostForm());
  }
}
