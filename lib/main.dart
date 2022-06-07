import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase_options.dart';
import 'package:instagram_clone/providers/current_user.dart';
import 'package:instagram_clone/providers/favorite_posts.dart';
import 'package:instagram_clone/providers/posts.dart';
import 'package:instagram_clone/screens/auth_screen.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        ChangeNotifierProvider<CurrentUser>(
          create: (context) => CurrentUser(null, null),
        )
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
                  future: Provider.of<CurrentUser>(context, listen: false)
                      .fetchData(),
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
        },
      ),
    );
  }
}
