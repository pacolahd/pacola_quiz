import 'package:cloud_firestore/cloud_firestore.dart';
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
    required super.createdBy, // Add this line
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
          createdBy: '_empty.userId', // Add this line
        );

  CourseModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          title: map['title'] as String,
          description: map['description'] as String?,
          numberOfQuizzes: (map['number_of_quizzes'] as num).toInt(),
          numberOfMaterials: (map['number_of_materials'] as num).toInt(),
          image: map['image'] as String?,
          createdAt: (map['createdAt'] as Timestamp).toDate(),
          updatedAt: (map['updatedAt'] as Timestamp).toDate(),
          createdBy: map['created_by'] as String, // Add this line
        );

  DataMap toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'image': image,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'number_of_quizzes': numberOfQuizzes,
        'number_of_materials': numberOfMaterials,
        'created_by': createdBy, // Add this line
      };

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    int? numberOfQuizzes,
    int? numberOfMaterials,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
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
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
