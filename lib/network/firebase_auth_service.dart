import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_hub/main.dart';
import 'package:food_hub/providers/auth/auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  User? user = FirebaseAuth.instance.currentUser;

  bool get isLoggedIn => user != null;

  Stream<User?> get authStateChange => FirebaseAuth.instance.authStateChanges();

  Future<Either<String, User>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final isVerified = FirebaseAuth.instance.currentUser?.emailVerified;
      if (!isVerified!) {
        return left("Email isn't verified");
      }
      return right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        return left("Wrong information");
      } else if (e.code == 'invalid-email') {
        return left("Invalid Email");
      }
      return left("Some error occurs. Fail to login");
    } catch (e) {
      return left("Some error occurs. Fail to login");
    }
  }

  Future<Either<String, User>> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      });
      return right(userCredential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return left("Email is already used");
      } else if (e.code == 'invalid-email') {
        return left("Invalid Email");
      }
      print(e.message);
      return left("Some error occurs. Fail to sign up");
    } catch (e) {
      print(e.toString());
      return left("Some error occurs. Fail to sign up");
    }
  }

  Future<Either<String, User>> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

      return right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        return left("Wrong information");
      } else if (e.code == 'invalid-email') {
        return left("Invalid Email");
      }
      return left("Some error occurs. Fail to login");
    } catch (e) {
      print(e.toString());
      return left("Some error occurs. Fail to login");
    }
  }

  Future<void> sendPhoneVerifyCode(
      String phoneNumber,
      Function(String verificationId, int? resendToken) callback
          ) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          print("verificationCompleted");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("verificationFailed");
        },
        codeSent: callback,
          // print("111111111111111 " + verificationId);
          // ref.read(loadingProvider.notifier).update((state) => false);
          // ref.read(phoneLoginVerificationId.notifier).update((state) => verificationId);

        codeAutoRetrievalTimeout: (String verificationId) {
          print("codeAutoRetrievalTimeout");
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Either<String, User>> verifyOTPCode(
      String verificationId, String code) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return right(userCredential.user!);
    } catch (e) {
      return left(e.toString());
    }
  }

  void signOut() {
      FirebaseAuth.instance.signOut();
      GoogleSignIn().signOut();
  }
}
