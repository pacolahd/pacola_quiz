import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pacola_quiz/core/enums/update_enums.dart';
import 'package:pacola_quiz/core/errors/exceptions.dart';
import 'package:pacola_quiz/core/utils/constants.dart';
import 'package:pacola_quiz/core/utils/datasource_utils.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<UserModel> signInWithGoogle();
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });

  Future<void> forgotPassword(String email);
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
  User? get currentUser;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore firestoreClient,
    required FirebaseStorage storageClient,
    required Connectivity connectivity,
  })  : _authClient = authClient,
        _firestoreClient = firestoreClient,
        _storageClient = storageClient,
        _connectivity = connectivity;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _firestoreClient;
  final FirebaseStorage _storageClient;
  final Connectivity _connectivity;

  @override
  User? get currentUser => _authClient.currentUser;

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      throw ServerException(
        message: e.message ?? 'Password reset failed',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      final userCredential = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }

      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        return UserModel.fromMap(userData.data()!);
      }

      // upload the user
      await _setUserData(user, email);

      userData = await _getUserData(user.uid);
      return UserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      throw ServerException(
        message: e.message ?? 'Authentication failed',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);

      final userCredential = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }

      await user.updateDisplayName(fullName);
      await user.updatePhotoURL(kDefaultAvatar);

      await _setUserData(_authClient.currentUser!, email);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      throw ServerException(
        message: e.message ?? 'Sign up failed',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_authClient);

      final user = _authClient.currentUser!;
      switch (action) {
        case UpdateUserAction.email:
          await user.updateEmail(userData as String);
          await _updateUserData({'email': userData});
        case UpdateUserAction.fullName:
          await user.updateDisplayName(userData as String);
          await _updateUserData({'fullName': userData});
        case UpdateUserAction.profilePic:
          final ref = _storageClient
              .ref()
              .child('profile_pics/${_authClient.currentUser?.uid}');

          await ref.putFile(userData as File);
          final url = await ref.getDownloadURL();
          await user.updatePhotoURL(url);
          await _updateUserData({'profilePic': url});
        case UpdateUserAction.password:
          if (user.email == null) {
            throw const ServerException(
              message: 'User does not exist',
              statusCode: 'Insufficient Permission',
            );
          }
          final newData = jsonDecode(userData as String) as DataMap;
          await user.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: user.email!,
              password: newData['oldPassword'] as String,
            ),
          );
          await user.updatePassword(newData['newPassword'] as String);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      throw ServerException(
        message: e.message ?? 'Update failed',
        statusCode: e.code,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _firestoreClient.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(User user, String fallbackEmail) async {
    await _firestoreClient.collection('users').doc(user.uid).set(
          UserModel(
            id: user.uid,
            email: user.email?.toLowerCase() ?? fallbackEmail,
            fullName: user.displayName ?? '',
            profilePic: user.photoURL ?? kDefaultAvatar,
          ).toMap(),
        );
  }

  Future<void> _updateUserData(Map<String, dynamic> data) async {
    await _firestoreClient
        .collection('users')
        .doc(_authClient.currentUser!.uid)
        .update(data);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);

      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw const ServerException(
          message: 'Google sign-in was aborted by the user',
          statusCode: 'auth/sign-in-canceled',
        );
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _authClient.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        throw const ServerException(
          message: 'Google sign-in failed. Please try again later',
          statusCode: 'auth/google-signin-failed',
        );
      }

      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        await _setUserData(user, googleUser.email);
        userData = await _getUserData(user.uid);
      }

      return UserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      throw ServerException(
        message: e.message ?? 'Google sign-in failed',
        statusCode: e.code,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }
}
