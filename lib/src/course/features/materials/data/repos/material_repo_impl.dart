import 'package:dartz/dartz.dart';
import 'package:pacola_quiz/core/enums/update_enums.dart';
import 'package:pacola_quiz/core/errors/exceptions.dart';
import 'package:pacola_quiz/core/errors/failures.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/materials/data/datasources/material_remote_data_src.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/entities/material.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/repos/material_repo.dart';

class MaterialRepoImpl implements MaterialRepo {
  const MaterialRepoImpl(this._remoteDataSource);

  final MaterialRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<Resource>> getMaterials(String courseId) async {
    try {
      final result = await _remoteDataSource.getMaterials(courseId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> addMaterial(Resource material) async {
    try {
      await _remoteDataSource.addMaterial(material);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateMaterial({
    required UpdateMaterialAction action,
    required String materialId,
    required dynamic materialData,
  }) async {
    try {
      await _remoteDataSource.updateMaterial(
          action: action, materialId: materialId, materialData: materialData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> deleteMaterial(String materialId) async {
    try {
      await _remoteDataSource.deleteMaterial(materialId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Resource>> getMaterialsForQuiz(
      String courseId, String quizId) async {
    try {
      final materials =
          await _remoteDataSource.getMaterialsForQuiz(courseId, quizId);
      return Right(materials);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
