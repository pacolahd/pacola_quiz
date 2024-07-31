import 'package:bloc/bloc.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/usecases/get_quiz_questions.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/usecases/get_quizzes.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/usecases/get_quizzes_using_material.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/usecases/get_user_course_quizzes.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/usecases/get_user_quizzes.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/usecases/submit_quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/usecases/update_quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/usecases/uplad_quiz.dart';

import 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit({
    required GetQuizQuestions getQuizQuestions,
    required GetQuizzes getQuizzes,
    required SubmitQuiz submitQuiz,
    required UpdateQuiz updateQuiz,
    required UploadQuiz uploadQuiz,
    required GetUserCourseQuizzes getUserCourseQuizzes,
    required GetUserQuizzes getUserQuizzes,
    required GetQuizzesUsingMaterial getQuizzesUsingMaterial,
  })  : _getQuizQuestions = getQuizQuestions,
        _getQuizzes = getQuizzes,
        _submitQuiz = submitQuiz,
        _updateQuiz = updateQuiz,
        _uploadQuiz = uploadQuiz,
        _getUserCourseQuizzes = getUserCourseQuizzes,
        _getUserQuizzes = getUserQuizzes,
        _getQuizzesUsingMaterial = getQuizzesUsingMaterial,
        super(const QuizInitial());

  final GetQuizQuestions _getQuizQuestions;
  final GetQuizzes _getQuizzes;
  final SubmitQuiz _submitQuiz;
  final UpdateQuiz _updateQuiz;
  final UploadQuiz _uploadQuiz;
  final GetUserCourseQuizzes _getUserCourseQuizzes;
  final GetUserQuizzes _getUserQuizzes;
  final GetQuizzesUsingMaterial _getQuizzesUsingMaterial;

  Future<void> getQuizQuestions(Quiz exam) async {
    emit(const GettingQuizQuestions());
    final result = await _getQuizQuestions(exam);
    result.fold(
      (failure) => emit(QuizError(failure.errorMessage)),
      (questions) => emit(QuizQuestionsLoaded(questions)),
    );
  }

  Future<void> getQuizzes(String courseId) async {
    emit(const GettingQuizzes());
    final result = await _getQuizzes(courseId);
    result.fold(
      (failure) => emit(QuizError(failure.errorMessage)),
      (exams) => emit(QuizzesLoaded(exams)),
    );
  }

  Future<void> submitQuiz(UserQuiz exam) async {
    emit(const SubmittingQuiz());
    final result = await _submitQuiz(exam);
    result.fold(
      (failure) => emit(QuizError(failure.errorMessage)),
      (_) => emit(const QuizSubmitted()),
    );
  }

  Future<void> updateQuiz(Quiz exam) async {
    emit(const UpdatingQuiz());
    final result = await _updateQuiz(exam);
    result.fold(
      (failure) => emit(QuizError(failure.errorMessage)),
      (_) => emit(const QuizUpdated()),
    );
  }

  Future<void> uploadQuiz(Quiz exam) async {
    emit(const UploadingQuiz());
    final result = await _uploadQuiz(exam);
    result.fold(
      (failure) => emit(QuizError(failure.errorMessage)),
      (_) => emit(const QuizUploaded()),
    );
  }

  Future<void> getUserCourseQuizzes(String courseId) async {
    emit(const GettingUserQuizzes());
    final result = await _getUserCourseQuizzes(courseId);
    result.fold(
      (failure) => emit(QuizError(failure.errorMessage)),
      (exams) => emit(UserCourseQuizzesLoaded(exams)),
    );
  }

  Future<void> getUserQuizzes() async {
    emit(const GettingUserQuizzes());
    final result = await _getUserQuizzes();
    result.fold(
      (failure) => emit(QuizError(failure.errorMessage)),
      (exams) => emit(UserQuizzesLoaded(exams)),
    );
  }

  Future<void> getQuizzesUsingMaterial(String materialId) async {
    emit(const GettingQuizzes());
    final result = await _getQuizzesUsingMaterial(materialId);
    result.fold(
      (failure) => emit(QuizError(failure.errorMessage)),
      (quizzes) => emit(QuizzesLoaded(quizzes)),
    );
  }
}
