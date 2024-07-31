import 'package:pacola_quiz/core/enums/update_enums.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/entities/material.dart';

abstract class MaterialRepo {
  const MaterialRepo();

  ResultFuture<List<Resource>> getMaterials(String courseId);

  ResultFuture<void> addMaterial(Resource material);

  ResultFuture<void> updateMaterial({
    required UpdateMaterialAction action,
    required String materialId,
    required dynamic materialData,
  });

  ResultFuture<void> deleteMaterial(String materialId);

  ResultFuture<List<Resource>> getMaterialsForQuiz(
      String courseId, String quizId);
}
