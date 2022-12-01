import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_admin/firebase_admin.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return "Signed out";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> deleteAuth(String uid) async {
    var credential = Credentials.applicationDefault();
    var app = await FirebaseAdmin.instance.initializeApp(
        AppOptions(credential: credential!, projectId: "Prepactive"));
    try {
      await app.auth().deleteUser(uid);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
