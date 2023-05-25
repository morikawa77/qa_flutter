import 'package:firebase_auth/firebase_auth.dart';

class AnonymousAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential;
    } catch (e) {
      // ignore: avoid_print
      print("Error signing in anonymously: $e");
      return null;
    }
  }
}

class EmailPasswordAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } catch (e) {
      // ignore: avoid_print
      print("Error signing in with email and password: $e");
      return null;
    }
  }
}

class EmailPasswordRegistration {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> registerWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
      return userCredential;
    } catch (e) {
      // ignore: avoid_print
      print("Error creating user with email and password: $e");
      return null;
    }
  }
}