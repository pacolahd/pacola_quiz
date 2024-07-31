import 'package:equatable/equatable.dart';

class Resource extends Equatable {
  const Resource({
    required this.id,
    required this.courseId,
    required this.uploadDate,
    required this.fileURL,
    required this.fileExtension,
    required this.uploadedBy,
    this.title,
    this.description,
    this.usedInQuizzes = const [],
  });

  final String id;
  final String courseId;
  final String? title;
  final String? description;
  final DateTime uploadDate;
  final String fileURL;
  final String fileExtension;
  final String uploadedBy;
  final List<String> usedInQuizzes;

  @override
  List<Object?> get props => [id];
}
