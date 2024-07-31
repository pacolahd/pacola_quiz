import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/entities/material.dart';

class MaterialModel extends Material {
  const MaterialModel({
    required super.id,
    required super.courseId,
    required super.quizId,
    required super.uploadDate,
    required super.fileURL,
    required super.fileExtension,
    super.title,
    super.description,
  });

  MaterialModel.empty([DateTime? date])
      : this(
          id: '_empty.id',
          courseId: '_empty.courseId',
          quizId: '_empty.quizId',
          title: '_empty.title',
          description: '_empty.description',
          uploadDate: date ?? DateTime.now(),
          fileExtension: '_empty.fileExtension',
          fileURL: '_empty.fileURL',
        );

  MaterialModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          courseId: map['courseId'] as String,
          quizId: map['quizId'] as String,
          title: map['title'] as String?,
          description: map['description'] as String?,
          uploadDate: DateTime.parse(map['uploadDate'] as String),
          fileExtension: map['fileExtension'] as String,
          fileURL: map['fileURL'] as String,
        );

  MaterialModel copyWith({
    String? id,
    String? courseId,
    String? quizId,
    String? title,
    String? description,
    DateTime? uploadDate,
    String? fileExtension,
    String? fileURL,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      quizId: quizId ?? this.quizId,
      title: title ?? this.title,
      description: description ?? this.description,
      uploadDate: uploadDate ?? this.uploadDate,
      fileURL: fileURL ?? this.fileURL,
      fileExtension: fileExtension ?? this.fileExtension,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'quizId': quizId,
      'title': title,
      'description': description,
      'uploadDate': uploadDate.toIso8601String(),
      'fileURL': fileURL,
      'fileExtension': fileExtension,
    };
  }
}
