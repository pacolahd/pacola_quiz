import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/quizzes/data/models/question_choice_model.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/question_choice.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz_question.dart';

class QuizQuestionModel extends QuizQuestion {
  const QuizQuestionModel({
    required super.id,
    required super.courseId,
    required super.quizId,
    required super.questionText,
    required super.choices,
    super.correctAnswer,
  });

  const QuizQuestionModel.empty()
      : this(
          id: 'Test String',
          quizId: 'Test String',
          courseId: 'Test String',
          questionText: 'Test String',
          choices: const [],
          correctAnswer: 'Test String',
        );

  QuizQuestionModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          quizId: map['quizId'] as String,
          courseId: map['courseId'] as String,
          questionText: map['questionText'] as String,
          correctAnswer: map['correctAnswer'] as String,
          choices: List<DataMap>.from(map['choices'] as List<dynamic>)
              .map(QuestionChoiceModel.fromMap)
              .toList(),
        );

  QuizQuestionModel.fromUploadMap(DataMap map)
      : this(
          id: map['id'] as String? ?? '',
          quizId: map['quizId'] as String? ?? '',
          courseId: map['courseId'] as String? ?? '',
          questionText: map['question'] as String,
          correctAnswer: map['correct_answer'] as String,
          choices: List<DataMap>.from(map['answers'] as List<dynamic>)
              .map(QuestionChoiceModel.fromUploadMap)
              .toList(),
        );

  QuizQuestionModel copyWith({
    String? id,
    String? quizId,
    String? courseId,
    String? questionText,
    List<QuestionChoice>? choices,
    String? correctAnswer,
  }) {
    return QuizQuestionModel(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      courseId: courseId ?? this.courseId,
      questionText: questionText ?? this.questionText,
      choices: choices ?? this.choices,
      correctAnswer: correctAnswer ?? this.correctAnswer,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'quizId': quizId,
      'courseId': courseId,
      'questionText': questionText,
      'choices': choices
          .map((choice) => (choice as QuestionChoiceModel).toMap())
          .toList(),
      'correctAnswer': correctAnswer,
    };
  }
}
