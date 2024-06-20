import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? user;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      this.user = user;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> registerUser(
    String email,
    String password,
    String displayName,
    File? profileImage,
  ) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    user = userCredential.user;
    print('USER: ${user}');

    String? photoURL;
    if (profileImage != null) {
      photoURL = await uploadProfilePicture(profileImage);
    }

    await _firestore.collection('users').doc(user?.uid).set({
      'displayName': displayName,
      'photoURL': photoURL,
      'email': email,
    });

    await user?.reload();
    user = _auth.currentUser;
    notifyListeners();
  }

  uploadProfilePicture(File file) async {
    try {
      await _storage.ref('profile_pictures/${user?.uid}').putFile(file);
      return await _storage
          .ref('profile_pictures/${user?.uid}')
          .getDownloadURL();
    } catch (e) {
      print('Error....: ${e}');
    }
  }

  Future<void> updateProfile(
      String displayName, String newEmail, String? photoURL) async {
    // try {
    //   FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(newEmail);
    // } catch (e) {
    //   print('Errrrrrr: ${e}');
    // }

    await _firestore.collection('users').doc(user?.uid).set({
      'displayName': displayName,
      'photoURL': photoURL,
      'email': newEmail,
    }, SetOptions(merge: true));
    await user?.reload();
    user = _auth.currentUser;
    notifyListeners();
  }

  Future<Map<String, String>> getUserProfile() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      return {
        'displayName': doc['displayName'],
        'photoURL': doc['photoURL'],
      };
    } on FirebaseAuthException catch (e) {
      return {
        'error': '${e.code}',
      };
    }
  }
}
