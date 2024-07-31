import 'package:pacola_quiz/core/usecases/usecases.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz_question.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/repos/quiz_repo.dart';

class GetQuizQuestions
    extends FutureUsecaseWithParams<List<QuizQuestion>, Quiz> {
  const GetQuizQuestions(this._repo);

  final QuizRepo _repo;

  @override
  ResultFuture<List<QuizQuestion>> call(Quiz params) =>
      _repo.getQuizQuestions(params);
}
