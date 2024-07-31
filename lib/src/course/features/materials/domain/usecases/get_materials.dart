import 'package:pacola_quiz/core/usecases/usecases.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/entities/material.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/repos/material_repo.dart';

class GetMaterials extends FutureUsecaseWithParams<List<Resource>, String> {
  const GetMaterials(this._repo);

  final MaterialRepo _repo;

  @override
  ResultFuture<List<Resource>> call(String params) =>
      _repo.getMaterials(params);
}
