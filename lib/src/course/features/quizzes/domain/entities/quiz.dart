import 'package:equatable/equatable.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz_question.dart';

class Quiz extends Equatable {
  const Quiz({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.timeLimit,
    this.imageUrl,
    this.questions,
  });

  const Quiz.empty()
      : this(
          id: 'Test String',
          courseId: 'Test String',
          title: 'Test String',
          description: 'Test String',
          timeLimit: 0,
          questions: const [],
        );

  final String id;
  final String courseId;
  final String title;
  final String? imageUrl;
  final String description;
  final int timeLimit;
  final List<QuizQuestion>? questions;

  @override
  List<Object?> get props => [id, courseId];
}
