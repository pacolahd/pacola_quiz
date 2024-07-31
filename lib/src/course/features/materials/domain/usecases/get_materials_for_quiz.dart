// get_materials_for_quiz.dart
import 'package:equatable/equatable.dart';
import 'package:pacola_quiz/core/usecases/usecases.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/entities/material.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/repos/material_repo.dart';

class GetMaterialsForQuiz
    implements
        FutureUsecaseWithParams<List<Resource>, GetMaterialsForQuizParams> {
  const GetMaterialsForQuiz(this._repo);

  final MaterialRepo _repo;

  @override
  ResultFuture<List<Resource>> call(GetMaterialsForQuizParams params) =>
      _repo.getMaterialsForQuiz(params.courseId, params.quizId);
}

class GetMaterialsForQuizParams extends Equatable {
  const GetMaterialsForQuizParams(
      {required this.courseId, required this.quizId});

  final String courseId;
  final String quizId;

  @override
  List<Object?> get props => [courseId, quizId];
}
