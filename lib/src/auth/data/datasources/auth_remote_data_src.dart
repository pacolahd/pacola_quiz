import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pacola_quiz/core/enums/update_user.dart';
import 'package:pacola_quiz/core/errors/exceptions.dart';
import 'package:pacola_quiz/core/utils/constants.dart';
import 'package:pacola_quiz/core/utils/datasource_utils.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signInWithGoogle();
  Future<void> signUp({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  });
  Future<void> forgotPassword(String email);
  Future<void> updateUser({required UpdateUserAction action, dynamic userData});
  Session? get currentSession;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required SupabaseClient supabaseClient,
    required Connectivity connectivity,
  })  : _supabaseClient = supabaseClient,
        _connectivity = connectivity;

  final SupabaseClient _supabaseClient;
  final Connectivity _connectivity;

  @override
  Session? get currentSession => _supabaseClient.auth.currentSession;

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);

      await _supabaseClient.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: 'auth/error',
      );
    } catch (e) {
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
      final result = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }

      var userData = await _getUserData(user.id);

      if (userData != null) {
        return UserModel.fromMap(userData);
      }

      // upload the user
      await _setUserData(user);

      userData = await _getUserData(user.id);
      return UserModel.fromMap(userData!);
    } on AuthException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: 'auth/error',
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
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);

      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'profile_pic': kDefaultAvatar,
        },
        // emailRedirectTo: kIsWeb ? null : kEmailRedirectTo,
      );

      if (response.user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }

      await _setUserData(response.user!);
    } on AuthException catch (e) {
      debugPrint(e.message);
      throw ServerException(
        message: e.message,
        statusCode: 'auth/error',
      );
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    dynamic userData,
  }) async {
    try {
      // Check for internet connection
      await DataSourceUtils.checkInternetConnection(_connectivity);

      // Authorize user
      await DataSourceUtils.authorizeUser(_supabaseClient);

      final userId = _supabaseClient.auth.currentUser!.id;
      switch (action) {
        case UpdateUserAction.email:
          await _supabaseClient.auth.updateUser(UserAttributes(
            email: userData as String,
          ));
          await _updateUserData({'email': userData});
        case UpdateUserAction.firstName:
          await _updateUserData({'first_name': userData as String});
        case UpdateUserAction.lastName:
          await _updateUserData({'last_name': userData as String});
        case UpdateUserAction.profilePic:
          final filePath = '$userId/profile_pic/profile_image';
          await _supabaseClient.storage.from('user_data').upload(
              filePath, userData as File,
              fileOptions: const FileOptions(upsert: true));
          final url =
              _supabaseClient.storage.from('users').getPublicUrl(filePath);
          await _updateUserData({'profile_pic': url});
        case UpdateUserAction.password:
          if (_supabaseClient.auth.currentUser?.email == null) {
            throw const ServerException(
              message: 'User does not exist',
              statusCode: 'Insufficient Permission',
            );
          }
          final newData = jsonDecode(userData as String) as DataMap;
          await _supabaseClient.auth.updateUser(
            UserAttributes(password: newData['newPassword'] as String),
          );
      }
    } on AuthException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: 'auth/error',
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  Future<Map<String, dynamic>?> _getUserData(String uid) async {
    final response =
        await _supabaseClient.from('users').select().eq('id', uid).single();
    return response;
  }

  Future<void> _setUserData(User user) async {
    await _supabaseClient.from('users').upsert(
          UserModel(
            id: user.id,
            email: user.email?.toLowerCase() ?? '',
            firstName: user.userMetadata?['first_name'] as String ?? '',
            lastName: user.userMetadata?['last_name'] as String ?? '',
            profilePic:
                user.userMetadata?['profile_pic'] as String? ?? kDefaultAvatar,
          ).toMap(),
        );
  }

  Future<void> _updateUserData(Map<String, dynamic> data) async {
    await _supabaseClient
        .from('users')
        .update(data)
        .eq('id', _supabaseClient.auth.currentUser!.id);
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

      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw const ServerException(
          message: 'No Access Token found.',
          statusCode: 'auth/no-access-token',
        );
      }
      if (idToken == null) {
        throw const ServerException(
          message: 'No ID Token found.',
          statusCode: 'auth/no-id-token',
        );
      }

      final response = await _supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = response.user;

      if (user == null) {
        throw const ServerException(
          message: 'Google sign-in failed. Please try again later',
          statusCode: 'auth/google-signin-failed',
        );
      }

      var userData = await _getUserData(user.id);

      if (userData == null) {
        await _setUserData(user);
        userData = await _getUserData(user.id);
      }

      return UserModel.fromMap(userData!);
    } on AuthException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: 'auth/error',
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }
}
