import 'package:pacola_quiz/core/usecases/usecases.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/auth/domain/repositories/auth_repo.dart';

class ForgotPassword implements FutureUsecaseWithParams<void, String> {
  const ForgotPassword(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<void> call(String email) => _repository.forgotPassword(email);
}
