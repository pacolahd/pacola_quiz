// lib/features/auth/domain/usecases/sign_in_with_google.dart
import 'package:pacola_quiz/core/usecases/usecases.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/auth/domain/entities/user_entity.dart';
import 'package:pacola_quiz/src/auth/domain/repositories/auth_repo.dart';

class SignInWithGoogle implements FutureUsecaseWithoutParams<UserEntity> {
  const SignInWithGoogle(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<UserEntity> call() => _repository.signInWithGoogle();
}
