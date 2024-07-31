import 'package:pacola_quiz/core/usecases/usecases.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/repos/quiz_repo.dart';

class GetUserCourseQuizzes
    extends FutureUsecaseWithParams<List<UserQuiz>, String> {
  const GetUserCourseQuizzes(this._repo);

  final QuizRepo _repo;

  @override
  ResultFuture<List<UserQuiz>> call(String params) =>
      _repo.getUserCourseQuizzes(params);
}
