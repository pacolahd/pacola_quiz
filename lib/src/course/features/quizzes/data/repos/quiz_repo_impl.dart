import 'package:dartz/dartz.dart';
import 'package:pacola_quiz/core/errors/exceptions.dart';
import 'package:pacola_quiz/core/errors/failures.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/quizzes/data/datasources/quiz_remote_data_src.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz_question.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/repos/quiz_repo.dart';

class QuizRepoImpl implements QuizRepo {
  const QuizRepoImpl(this._remoteDataSource);

  final QuizRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<Quiz>> getQuizzes(String courseId) async {
    try {
      final result = await _remoteDataSource.getQuizzes(courseId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<QuizQuestion>> getQuizQuestions(Quiz quiz) async {
    try {
      final result = await _remoteDataSource.getQuizQuestions(quiz);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> uploadQuiz(Quiz quiz) async {
    try {
      await _remoteDataSource.uploadQuiz(quiz);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateQuiz(Quiz quiz) async {
    try {
      await _remoteDataSource.updateQuiz(quiz);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> submitQuiz(UserQuiz quiz) async {
    try {
      await _remoteDataSource.submitQuiz(quiz);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<UserQuiz>> getUserQuizzes() async {
    try {
      final result = await _remoteDataSource.getUserQuizzes();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<UserQuiz>> getUserCourseQuizzes(String courseId) async {
    try {
      final result = await _remoteDataSource.getUserCourseQuizzes(courseId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Quiz>> getQuizzesUsingMaterial(String materialId) async {
    try {
      final quizzes =
          await _remoteDataSource.getQuizzesUsingMaterial(materialId);
      return Right(quizzes);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
