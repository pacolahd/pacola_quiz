// lib/features/auth/domain/usecases/sign_in.dart
import 'package:equatable/equatable.dart';
import 'package:pacola_quiz/core/usecases/usecases.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/auth/domain/entities/user_entity.dart';
import 'package:pacola_quiz/src/auth/domain/repositories/auth_repo.dart';

class SignIn implements FutureUsecaseWithParams<UserEntity, SignInParams> {
  const SignIn(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<UserEntity> call(SignInParams params) => _repository.signIn(
        email: params.email,
        password: params.password,
      );
}

class SignInParams extends Equatable {
  const SignInParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
