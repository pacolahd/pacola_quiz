import 'package:pacola_quiz/core/enums/update_enums.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/domain/entities/course.dart';

abstract class CourseRepo {
  const CourseRepo();

  ResultFuture<List<Course>> getCourses();

  ResultFuture<void> addCourse(Course course);

  ResultFuture<void> updateCourse({
    required UpdateCourseAction action,
    required String courseId,
    required dynamic courseData,
  });

  ResultFuture<void> deleteCourse(String courseId);
}
