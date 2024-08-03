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
        password: params.password,
        fullName: params.fullName,
      );
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.fullName,
    required this.password,
  });

  const SignUpParams.empty() : this(email: '', password: '', fullName: '');

  final String email;
  final String fullName;
  final String password;

  @override
  List<Object?> get props => [email, fullName, password];
}
