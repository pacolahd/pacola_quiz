import 'package:pacola_quiz/core/usecases/usecases.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/domain/repos/course_repo.dart';

class DeleteCourse extends FutureUsecaseWithParams<void, String> {
  const DeleteCourse(this._repo);

  final CourseRepo _repo;

  @override
  ResultFuture<void> call(String params) async => _repo.deleteCourse(params);
}
