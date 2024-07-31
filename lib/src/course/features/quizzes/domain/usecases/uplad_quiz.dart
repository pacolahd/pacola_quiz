import 'package:pacola_quiz/core/usecases/usecases.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/repos/quiz_repo.dart';

class UploadQuiz extends FutureUsecaseWithParams<void, Quiz> {
  const UploadQuiz(this._repo);

  final QuizRepo _repo;

  @override
  ResultFuture<void> call(Quiz params) => _repo.uploadQuiz(params);
}
