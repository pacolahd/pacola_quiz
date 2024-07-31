import 'package:equatable/equatable.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz_question.dart';

class Quiz extends Equatable {
  const Quiz({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.timeLimit,
    required this.createdBy,
    this.imageUrl,
    this.questions,
    this.materialIds = const [],
  });

  final String id;
  final String courseId;
  final String title;
  final String description;
  final int timeLimit;
  final String? imageUrl;
  final List<QuizQuestion>? questions;
  final String createdBy;
  final List<String> materialIds;

  @override
  List<Object?> get props => [id];
}
