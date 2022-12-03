import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/authentication_service.dart';
import 'package:project/pages/feed_page.dart';
import 'package:project/services/firestore_repository.dart';
import 'package:project/services/repository.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'signInPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //name: "Prepacktive",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (context) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider<User?>(
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

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return Provider<Repository>(
        create: (_) => FirestoreRepository(),
        builder: (context, child) {
          return FeedPage();
        },
      );
    } else {
      return SignInPage();
    }
  }
}
