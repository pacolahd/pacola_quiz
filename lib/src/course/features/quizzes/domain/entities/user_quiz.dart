import 'package:equatable/equatable.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_choice.dart';

class UserQuiz extends Equatable {
  const UserQuiz({
    required this.quizId,
    required this.courseId,
    required this.totalQuestions,
    required this.quizTitle,
    required this.dateSubmitted,
    required this.answers,
    required this.score,
    this.quizImageUrl,
  });

  UserQuiz.empty([DateTime? date])
      : this(
          quizId: 'Test String',
          courseId: 'Test String',
          totalQuestions: 0,
          quizTitle: 'Test String',
          quizImageUrl: 'Test String',
          dateSubmitted: date ?? DateTime.now(),
          answers: const [],
          score: 0,
        );

  final String quizId;
  final String courseId;
  final int totalQuestions;
  final String quizTitle;
  final String? quizImageUrl;
  final DateTime dateSubmitted;
  final List<UserChoice> answers;
  final int score;

  @override
  List<Object?> get props => [quizId, courseId];
}
