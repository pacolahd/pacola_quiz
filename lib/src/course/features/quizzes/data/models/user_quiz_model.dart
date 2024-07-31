import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/quizzes/data/models/user_choice_model.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_choice.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_quiz.dart';

class UserQuizModel extends UserQuiz {
  const UserQuizModel({
    required super.quizId,
    required super.courseId,
    required super.answers,
    required super.quizTitle,
    required super.totalQuestions,
    required super.dateSubmitted,
    super.quizImageUrl,
  });

  UserQuizModel.empty([DateTime? date])
      : this(
          quizId: 'Test String',
          courseId: 'Test String',
          totalQuestions: 0,
          quizTitle: 'Test String',
          quizImageUrl: 'Test String',
          dateSubmitted: date ?? DateTime.now(),
          answers: const [],
        );

  UserQuizModel.fromMap(DataMap map)
      : this(
          quizId: map['quizId'] as String,
          courseId: map['courseId'] as String,
          totalQuestions: (map['totalQuestions'] as num).toInt(),
          quizTitle: map['quizTitle'] as String,
          quizImageUrl: map['quizImageUrl'] as String?,
          dateSubmitted: DateTime.parse(map['dateSubmitted'] as String),
          answers: List<DataMap>.from(map['answers'] as List<dynamic>)
              .map(UserChoiceModel.fromMap)
              .toList(),
        );

  UserQuizModel copyWith({
    String? quizId,
    String? courseId,
    int? totalQuestions,
    String? quizTitle,
    String? quizImageUrl,
    DateTime? dateSubmitted,
    List<UserChoice>? answers,
  }) {
    return UserQuizModel(
      quizId: quizId ?? this.quizId,
      courseId: courseId ?? this.courseId,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      quizTitle: quizTitle ?? this.quizTitle,
      quizImageUrl: quizImageUrl ?? this.quizImageUrl,
      dateSubmitted: dateSubmitted ?? this.dateSubmitted,
      answers: answers ?? this.answers,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'quizId': quizId,
      'courseId': courseId,
      'totalQuestions': totalQuestions,
      'quizTitle': quizTitle,
      'quizImageUrl': quizImageUrl,
      'dateSubmitted': DateTime.now().toIso8601String(),
      'answers':
          answers.map((answer) => (answer as UserChoiceModel).toMap()).toList(),
    };
  }
}
