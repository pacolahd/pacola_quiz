import 'package:pacola_quiz/core/usecases/usecases.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/repos/quiz_repo.dart';

class UpdateQuiz extends FutureUsecaseWithParams<void, Quiz> {
  const UpdateQuiz(this._repo);

  final QuizRepo _repo;

  @override
  ResultFuture<void> call(Quiz params) => _repo.updateQuiz(params);
}
