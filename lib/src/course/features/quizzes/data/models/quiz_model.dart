import 'dart:convert';

import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/quizzes/data/models/quiz_question_model.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz_question.dart';

class QuizModel extends Quiz {
  const QuizModel({
    required super.id,
    required super.courseId,
    required super.title,
    required super.description,
    required super.timeLimit,
    required super.createdBy,
    super.imageUrl,
    super.questions,
    super.materialIds,
  });

  factory QuizModel.fromJson(String source) =>
      QuizModel.fromUploadMap(jsonDecode(source) as DataMap);

  const QuizModel.empty()
      : this(
          id: 'Test String',
          courseId: 'Test String',
          title: 'Test String',
          description: 'Test String',
          timeLimit: 0,
          questions: const [],
          createdBy: 'Test String',
          materialIds: const [],
        );

  QuizModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          courseId: map['courseId'] as String,
          title: map['title'] as String,
          description: map['description'] as String,
          timeLimit: (map['timeLimit'] as num).toInt(),
          imageUrl: map['imageUrl'] as String?,
          questions: null,
          createdBy: map['createdBy'] as String,
          materialIds:
              List<String>.from(map['material_ids'] as List<dynamic>? ?? []),
        );

  QuizModel.fromUploadMap(DataMap map)
      : this(
          id: map['id'] as String? ?? '',
          courseId: map['courseId'] as String? ?? '',
          title: map['title'] as String,
          description: map['Description'] as String,
          timeLimit: (map['time_seconds'] as num).toInt(),
          imageUrl: (map['image_url'] as String).isEmpty
              ? null
              : map['image_url'] as String,
          questions: List<DataMap>.from(map['questions'] as List<dynamic>)
              .map(QuizQuestionModel.fromUploadMap)
              .toList(),
          createdBy: '',
          materialIds: [],
        );

  QuizModel copyWith({
    String? id,
    String? courseId,
    List<QuizQuestion>? questions,
    String? title,
    String? description,
    int? timeLimit,
    String? imageUrl,
    String? createdBy,
    List<String>? materialIds,
  }) {
    return QuizModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      questions: questions ?? this.questions,
      title: title ?? this.title,
      description: description ?? this.description,
      timeLimit: timeLimit ?? this.timeLimit,
      imageUrl: imageUrl ?? this.imageUrl,
      createdBy: createdBy ?? this.createdBy,
      materialIds: materialIds ?? this.materialIds,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'timeLimit': timeLimit,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'material_ids': materialIds,
    };
  }
}
