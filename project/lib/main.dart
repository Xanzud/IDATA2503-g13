import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project/authentication_service.dart';
import 'package:project/pages/feed_page.dart';
import 'package:project/pages/feed_page_admin.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'signInPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //name: "Prepactive",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp(key: null));
}

class MyApp extends StatelessWidget {
  const MyApp({required Key? key}) : super(key: key); //This is the semi-colon.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (context) =>
                AuthenticationService(Auth.FirebaseAuth.instance),
          ),
          StreamProvider<Auth.User?>(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
            initialData: null,
          ),
        ],
        child: MaterialApp(
          title: 'PrepActive',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: AuthenticationWrapper(),
        ));
  }
}

class AuthenticationWrapper extends StatefulWidget {
  @override
  _MainState createState() => new _MainState();
}

class _MainState extends State<AuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<Auth.User?>();
    if (firebaseUser != null) {
      if (firebaseUser.email == "admin@admin.com") {
        return LandingPageAdmin();
      } else {
        return FeedPage();
      }
    } else {
      return SignInPage();
    }
  }
}
