import 'package:pacola_quiz/core/usecases/usecases.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/repos/quiz_repo.dart';

class GetQuizzes extends FutureUsecaseWithParams<List<Quiz>, String> {
  const GetQuizzes(this._repo);

  final QuizRepo _repo;

  @override
  ResultFuture<List<Quiz>> call(String params) => _repo.getQuizzes(params);
}
