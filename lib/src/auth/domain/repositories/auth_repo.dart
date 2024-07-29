// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:pacola_quiz/core/enums/update_user.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  const AuthRepository();

  ResultFuture<UserEntity> signIn({
    required String email,
    required String password,
  });

  ResultFuture<UserEntity> signInWithGoogle();

  ResultFuture<void> signUp({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  });

  ResultFuture<void> forgotPassword(String email);

  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}
