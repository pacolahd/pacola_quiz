import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.numberOfQuizzes,
    required super.numberOfMaterials,
    required super.createdAt,
    required super.updatedAt,
    super.description,
    super.image,
  });

  CourseModel.empty()
      : this(
          id: '_empty.id',
          title: '_empty.title',
          description: '_empty.description',
          numberOfQuizzes: 0,
          numberOfMaterials: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

  CourseModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          title: map['title'] as String,
          description: map['description'] as String?,
          numberOfQuizzes: (map['numberOfQuizzes'] as num).toInt(),
          numberOfMaterials: (map['numberOfMaterials'] as num).toInt(),
          image: map['image'] as String?,
          createdAt: DateTime.parse(map['createdAt'] as String),
          updatedAt: DateTime.parse(map['updatedAt'] as String),
        );

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    int? numberOfQuizzes,
    int? numberOfMaterials,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      numberOfQuizzes: numberOfQuizzes ?? this.numberOfQuizzes,
      numberOfMaterials: numberOfMaterials ?? this.numberOfMaterials,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  DataMap toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'image': image,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'numberOfQuizzes': numberOfQuizzes,
        'numberOfMaterials': numberOfMaterials,
      };
}
