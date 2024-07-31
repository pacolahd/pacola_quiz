import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/entities/material.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/usecases/add_material.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/usecases/get_materials.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/usecases/get_materials_for_quiz.dart';

part 'material_state.dart';

class MaterialCubit extends Cubit<MaterialState> {
  MaterialCubit({
    required AddMaterial addMaterial,
    required GetMaterials getMaterials,
    required GetMaterialsForQuiz getMaterialsForQuiz,
  })  : _addMaterial = addMaterial,
        _getMaterials = getMaterials,
        _getMaterialsForQuiz = getMaterialsForQuiz,
        super(const MaterialInitial());

  final AddMaterial _addMaterial;
  final GetMaterials _getMaterials;
  final GetMaterialsForQuiz _getMaterialsForQuiz;

  Future<void> addMaterials(List<Resource> materials) async {
    emit(const AddingMaterials());

    for (final material in materials) {
      final result = await _addMaterial(material);
      result.fold(
        (failure) {
          emit(MaterialError(failure.errorMessage));
          return;
        },
        (_) => null,
      );
    }
    if (state is! MaterialError) emit(const MaterialsAdded());
  }

  Future<void> getMaterials(String courseId) async {
    emit(const LoadingMaterials());
    final result = await _getMaterials(courseId);
    result.fold(
      (failure) => emit(MaterialError(failure.errorMessage)),
      (materials) => emit(MaterialsLoaded(materials)),
    );
  }

  Future<void> getMaterialsForQuiz(String courseId, String quizId) async {
    emit(const LoadingMaterials());
    final result = await _getMaterialsForQuiz(
        GetMaterialsForQuizParams(courseId: courseId, quizId: quizId));
    result.fold(
      (failure) => emit(MaterialError(failure.errorMessage)),
      (materials) => emit(MaterialsLoaded(materials)),
    );
  }
}
