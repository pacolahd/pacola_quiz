import 'package:equatable/equatable.dart';

class Course extends Equatable {
  const Course({
    required this.id,
    required this.title,
    required this.numberOfQuizzes,
    required this.numberOfMaterials,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.description,
    this.image,
  });

  Course.empty()
      : this(
          id: '_empty.id',
          title: '_empty.title',
          description: '_empty.description',
          numberOfQuizzes: 0,
          numberOfMaterials: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          createdBy: '_empty.userId',
        );

  final String id;
  final String title;
  final String? description;
  final int numberOfQuizzes;
  final int numberOfMaterials;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  @override
  List<Object?> get props => [id];
}
