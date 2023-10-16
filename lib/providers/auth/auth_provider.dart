import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_hub/network/firebase_auth_service.dart';

import 'auth_state.dart';

final phoneLoginVerificationId = StateProvider<String?>((ref) => null);

final loginGeneralErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final signupGeneralErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final firebaseAuthServiceProvider = Provider((ref) => FirebaseAuthService());

final authStateProvider = StreamProvider<User?>(
    (ref) => ref.read(firebaseAuthServiceProvider).authStateChange);

class AuthNotifier extends StateNotifier<AuthenticationState> {
  AuthNotifier(this._firebaseAuthService)
      : super(const AuthenticationState.initial());

  final FirebaseAuthService _firebaseAuthService;

  Future<void> login({required String email, required String password}) async {
    state = const AuthenticationState.loading();
    final response = await _firebaseAuthService.signInWithEmailAndPassword(
        email: email, password: password);
    state = response.fold(
      (error) => AuthenticationState.unauthenticated(message: error),
      (response) => AuthenticationState.authenticated(user: response),
    );
  }

  Future<void> signup({required String email, required String password}) async {
    state = const AuthenticationState.loading();
    final response = await _firebaseAuthService.signUpWithEmailAndPassword(
        email: email, password: password);
    state = response.fold(
      (error) => AuthenticationState.unauthenticated(message: error),
      (response) => AuthenticationState.authenticated(user: response),
    );
  }

  Future<void> continueWithGoogle() async {
    state = const AuthenticationState.loading();
    final response = await _firebaseAuthService.signInWithGoogle();
    state = response.fold(
      (error) => AuthenticationState.unauthenticated(message: error),
      (response) => AuthenticationState.authenticated(user: response),
    );
  }

  Future<void> sendOTPCode(
      String phoneNumber,
      Function(String verificationId, int? resendToken) callback
          ) async {
    _firebaseAuthService.sendPhoneVerifyCode(phoneNumber, callback);
  }

  Future<void> verifyOTPCode(String verificationId, String code) async {
    state = const AuthenticationState.loading();
    final response =
        await _firebaseAuthService.verifyOTPCode(verificationId, code);
    state = response.fold(
      (error) => AuthenticationState.unauthenticated(message: error),
      (response) => AuthenticationState.authenticated(user: response),
    );
  }

  void signOut() {
      _firebaseAuthService.signOut();
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthenticationState>(
  (ref) =>
      AuthNotifier(ref.read(firebaseAuthServiceProvider)),
);
