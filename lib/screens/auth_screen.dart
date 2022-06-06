import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/auth_screen/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('Render -> Auth screen');
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: AuthForm(),
            ),
          ),
        ),
      ),
    );
  }
}
