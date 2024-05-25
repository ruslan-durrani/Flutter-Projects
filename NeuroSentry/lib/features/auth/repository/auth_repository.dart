import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    ref: ref,
    firebase: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  AuthRepository(
      {required this.auth, required this.ref, required this.firebase});

  final FirebaseAuth auth;
  final FirebaseFirestore firebase;
  AuthSignIn? signIn;
  ProviderRef ref;

  Future creatingUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    signIn = _CreateUserWithEmailAndPassword(
        auth: auth, email: email, password: password);
    await signIn?.signingIn();
  }

  Future signingInUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      signIn = _SignInUserWithEmailAndPassword(
          auth: auth, email: email, password: password);
      await signIn?.signingIn();
    } catch (e) {
      rethrow;
    }
  }

  Future googleSignIn() async {
    try {
      signIn = _SignInWithGoogle(auth: auth);
      await signIn?.signingIn();
    } catch (e) {
      rethrow;
    }
  }

  Future resetPassword({required String email}) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> checkProfileExists(String id) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('profileId', isEqualTo: id)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Error checking profile existence: $e');
    }
  }

  Future signingOut() async {
    try {
      await auth.signOut();
      //TODO RESET STUFF
    } catch (e) {
      debugPrint('Cannot Sign Out');
    }
  }
}

abstract class AuthSignIn {
  AuthSignIn({
    required this.auth,
  });

  final FirebaseAuth auth;

  Future signingIn();
  Future tryAndCatchBlock(Function function) async {
    try {
      await function();
    } catch (e) {
      rethrow;
    }
  }
}

class _CreateUserWithEmailAndPassword extends AuthSignIn {
  _CreateUserWithEmailAndPassword({
    required super.auth,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  Future signingIn() async {
    await tryAndCatchBlock(_creatingUser);
  }

  Future _creatingUser() async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }
}

class _SignInUserWithEmailAndPassword extends AuthSignIn {
  _SignInUserWithEmailAndPassword({
    required super.auth,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  Future signingIn() async {
    await tryAndCatchBlock(_signInUser);
  }

  Future _signInUser() async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }
}

class _SignInWithGoogle extends AuthSignIn {
  _SignInWithGoogle({
    required super.auth,
  });
  @override
  signingIn() async {
    final gUser = await _displayingSignInPage();
    final gAuth = await _obtainingDetails(gUser);
    await _signingInWithCredentials(_creatingCredentials(gAuth));
  }

  Future<GoogleSignInAccount?> _displayingSignInPage() async {
    return await GoogleSignIn().signIn();
  }

  Future<GoogleSignInAuthentication> _obtainingDetails(
      GoogleSignInAccount? gUser) async {
    return await gUser!.authentication;
  }

  _creatingCredentials(GoogleSignInAuthentication gAuth) {
    return GoogleAuthProvider.credential(
        idToken: gAuth.idToken, accessToken: gAuth.accessToken);
  }

  _signingInWithCredentials(AuthCredential credential) async {
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
