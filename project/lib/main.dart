import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project/authentication_service.dart';
import 'package:project/model/user.dart';
import 'package:project/pages/feed_page.dart';
import 'package:project/pages/feed_page_admin.dart';
import 'package:project/services/firebase_crud.dart';
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
  runApp( const MyApp(key: null));
}

class MyApp extends StatefulWidget {
const MyApp({required Key? key}) : super(key: key); //This is the semi-colon.

@override
_MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState(){
    super.initState();

    FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }
    });
  }

  // This widget is the root of your application.
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
      //return LandingPageAdmin();
      /*
      return FutureBuilder(
        future: FirebaseCrud.getUserByUid(firebaseUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data!;
            if (user.role == "admin") {
              return Provider<Repository>(
                create: (_) => FirestoreRepository(),
                builder: (context, child) {
                  return LandingPageAdmin();
                },
              );
            } else {
              return Provider<Repository>(
                create: (_) => FirestoreRepository(),
                builder: (context, child) {
                  return LandingPageAdmin();
                },
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("No data to load"),
            );
          }
          return SignInPage();
        },
      );
      */
    } else {
      return SignInPage();
    }
  }
}
