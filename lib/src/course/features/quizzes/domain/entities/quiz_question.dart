import 'package:equatable/equatable.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/question_choice.dart';

class QuizQuestion extends Equatable {
  const QuizQuestion({
    required this.id,
    required this.courseId,
    required this.quizId,
    required this.questionText,
    required this.choices,
    this.correctAnswer,
  });

  const QuizQuestion.empty()
      : this(
          id: 'Test String',
          quizId: 'Test String',
          courseId: 'Test String',
          questionText: 'Test String',
          choices: const [],
        );

  final String id;
  final String courseId;
  final String quizId;
  final String questionText;
  final String? correctAnswer;
  final List<QuestionChoice> choices;

  @override
  List<Object?> get props => [id, quizId, courseId];
}
