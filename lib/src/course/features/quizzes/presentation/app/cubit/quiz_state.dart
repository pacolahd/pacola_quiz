import 'package:equatable/equatable.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz_question.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_quiz.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object> get props => [];
}

class QuizInitial extends QuizState {
  const QuizInitial();
}

class GettingQuizzes extends QuizState {
  const GettingQuizzes();
}

class GettingUserQuizzes extends QuizState {
  const GettingUserQuizzes();
}

class GettingQuizQuestions extends QuizState {
  const GettingQuizQuestions();
}

class SubmittingQuiz extends QuizState {
  const SubmittingQuiz();
}

class UploadingQuiz extends QuizState {
  const UploadingQuiz();
}

class UpdatingQuiz extends QuizState {
  const UpdatingQuiz();
}

class QuizzesLoaded extends QuizState {
  const QuizzesLoaded(this.exams);

  final List<Quiz> exams;

  @override
  List<Object> get props => [exams];
}

class UserCourseQuizzesLoaded extends QuizState {
  const UserCourseQuizzesLoaded(this.exams);

  final List<UserQuiz> exams;

  @override
  List<Object> get props => [exams];
}

class UserQuizzesLoaded extends QuizState {
  const UserQuizzesLoaded(this.exams);

  final List<UserQuiz> exams;

  @override
  List<Object> get props => [exams];
}

class QuizQuestionsLoaded extends QuizState {
  const QuizQuestionsLoaded(this.questions);

  final List<QuizQuestion> questions;

  @override
  List<Object> get props => [questions];
}

class QuizSubmitted extends QuizState {
  const QuizSubmitted();
}

class QuizUploaded extends QuizState {
  const QuizUploaded();
}

class QuizUpdated extends QuizState {
  const QuizUpdated();
}

class QuizError extends QuizState {
  const QuizError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
