import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase_options.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/providers/following.dart';
import 'package:instagram_clone/providers/user.dart' as instagram_user;
import 'package:instagram_clone/providers/favorite_posts.dart';
import 'package:instagram_clone/providers/posts.dart';
import 'package:instagram_clone/screens/auth_screen.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/post_detail_screen.dart';
import 'package:instagram_clone/screens/splash_screen.dart';
import 'package:instagram_clone/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future loadData(BuildContext context) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    instagram_user.User user = Provider.of<instagram_user.User>(context, listen: false);
    user.id = firebaseUser!.uid;
    await user.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Posts>(
          create: (context) => Posts(),
        ),
        ChangeNotifierProvider<FavoritePosts>(
          create: (context) => FavoritePosts(),
        ),
        ChangeNotifierProvider<instagram_user.User>(
          create: (context) => instagram_user.User(null, null, null),
        ),
        ChangeNotifierProvider<Post>(
          create: (context) => Post(null, null, null, null, null, null, null, null),
        ),
        ChangeNotifierProvider<Following>(create: (context) => Following()),
      ],
      child: MaterialApp(
        title: 'Instagram',
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: loadData(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return const HomeScreen();
                  });
            }
            return const AuthScreen();
          },
        ),
        routes: {
          HomeScreen.routeName: (context) => const HomeScreen(),
          PostDetailScreen.routeName: (context) => const PostDetailScreen(),
          UserProfileScreen.routeName: (context) => const UserProfileScreen(),
        },
      ),
    );
  }
}
