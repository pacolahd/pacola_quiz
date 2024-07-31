import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz_question.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_quiz.dart';

abstract class QuizRepo {
  ResultFuture<List<Quiz>> getQuizzes(String courseId);
  ResultFuture<List<QuizQuestion>> getQuizQuestions(Quiz quiz);
  ResultFuture<void> uploadQuiz(Quiz quiz);
  ResultFuture<void> updateQuiz(Quiz quiz);
  ResultFuture<void> submitQuiz(UserQuiz quiz);
  ResultFuture<List<UserQuiz>> getUserQuizzes();
  ResultFuture<List<UserQuiz>> getUserCourseQuizzes(String courseId);
  ResultFuture<List<Quiz>> getQuizzesUsingMaterial(String materialId);
}
