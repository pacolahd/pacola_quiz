import 'package:pacola_quiz/core/usecases/usecases.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/repos/quiz_repo.dart';

class SubmitQuiz extends FutureUsecaseWithParams<void, UserQuiz> {
  const SubmitQuiz(this._repo);

  final QuizRepo _repo;

  @override
  ResultFuture<void> call(UserQuiz params) => _repo.submitQuiz(params);
}
