// lib/features/auth/domain/usecases/sign_up.dart
import 'package:equatable/equatable.dart';
import 'package:pacola_quiz/core/usecases/usecases.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/auth/domain/repositories/auth_repo.dart';

class SignUp implements FutureUsecaseWithParams<void, SignUpParams> {
  const SignUp(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<void> call(SignUpParams params) => _repository.signUp(
        email: params.email,
        firstName: params.firstName,
        lastName: params.lastName,
        password: params.password,
      );
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  final String email;
  final String firstName;
  final String lastName;
  final String password;

  @override
  List<Object?> get props => [email, firstName, lastName, password];
}
