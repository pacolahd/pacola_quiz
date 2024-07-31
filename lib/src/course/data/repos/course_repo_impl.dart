import 'package:dartz/dartz.dart';
import 'package:pacola_quiz/core/enums/update_enums.dart';
import 'package:pacola_quiz/core/errors/exceptions.dart';
import 'package:pacola_quiz/core/errors/failures.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/data/datasources/course_remote_data_src.dart';
import 'package:pacola_quiz/src/course/domain/entities/course.dart';
import 'package:pacola_quiz/src/course/domain/repos/course_repo.dart';

class CourseRepoImpl implements CourseRepo {
  const CourseRepoImpl(this._remoteDataSrc);

  final CourseRemoteDataSrc _remoteDataSrc;

  @override
  ResultFuture<void> addCourse(Course course) async {
    try {
      await _remoteDataSrc.addCourse(course);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Course>> getCourses() async {
    try {
      final courses = await _remoteDataSrc.getCourses();
      return Right(courses);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateCourse({
    required UpdateCourseAction action,
    required String courseId,
    required dynamic courseData,
  }) async {
    try {
      await _remoteDataSrc.updateCourse(
          action: action, courseId: courseId, courseData: courseData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> deleteCourse(String courseId) async {
    try {
      await _remoteDataSrc.deleteCourse(courseId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
