import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseAuthService {
  User? user = FirebaseAuth.instance.currentUser;
  bool get isLoggedIn => user != null;
   Future<void> signInWithEmailAndPassword(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

   Future<void> signUpWithEmailAndPassword(String email, String password) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }
}

final firebaseAuthServiceProvider = Provider((ref) => FirebaseAuthService());