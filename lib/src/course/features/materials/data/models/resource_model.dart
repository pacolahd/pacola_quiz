import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/entities/material.dart';

class ResourceModel extends Resource {
  const ResourceModel({
    required super.id,
    required super.courseId,
    required super.uploadDate,
    required super.fileURL,
    required super.fileExtension,
    required super.uploadedBy,
    super.title,
    super.description,
    super.usedInQuizzes,
  });

  ResourceModel.empty([DateTime? date])
      : this(
          id: '_empty.id',
          courseId: '_empty.courseId',
          title: '_empty.title',
          description: '_empty.description',
          uploadDate: date ?? DateTime.now(),
          fileExtension: '_empty.fileExtension',
          fileURL: '_empty.fileURL',
          uploadedBy: '_empty.userId',
          usedInQuizzes: const [],
        );

  ResourceModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          courseId: map['course_id'] as String,
          title: map['title'] as String?,
          description: map['description'] as String?,
          uploadDate: DateTime.parse(map['upload_date'] as String),
          fileExtension: map['file_extension'] as String,
          fileURL: map['file_url'] as String,
          uploadedBy: map['uploaded_by'] as String,
          // usedInQuizzes: (map['used_in_quizzes'] as List<dynamic>?)
          //         ?.map((e) => e as String)
          //         .toList() ??
          //     [],
          usedInQuizzes:
              List<String>.from(map['usedInQuizzes'] as List<dynamic>? ?? []),
        );

  DataMap toMap() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'upload_date': uploadDate.toIso8601String(),
      'file_url': fileURL,
      'file_extension': fileExtension,
      'uploaded_by': uploadedBy,
      'used_in_quizzes': usedInQuizzes,
    };
  }

  ResourceModel copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    DateTime? uploadDate,
    String? fileExtension,
    String? fileURL,
    String? uploadedBy,
    List<String>? usedInQuizzes,
  }) {
    return ResourceModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      uploadDate: uploadDate ?? this.uploadDate,
      fileURL: fileURL ?? this.fileURL,
      fileExtension: fileExtension ?? this.fileExtension,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      usedInQuizzes: usedInQuizzes ?? this.usedInQuizzes,
    );
  }
}
