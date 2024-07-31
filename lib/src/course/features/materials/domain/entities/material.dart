import 'package:equatable/equatable.dart';

class Material extends Equatable {
  const Material({
    required this.id,
    required this.courseId,
    required this.quizId,
    required this.uploadDate,
    required this.fileURL,
    required this.fileExtension,
    this.title,
    this.description,
  });

  final String id;
  final String courseId;
  final String quizId;
  final DateTime uploadDate;
  final String fileURL;
  final String fileExtension;
  final String? title;
  final String? description;

  @override
  List<Object?> get props => [id, courseId, quizId];
}
