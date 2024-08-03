import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/common/widgets/course_info_tile.dart';
import 'package:pacola_quiz/core/common/widgets/expandable_text.dart';
import 'package:pacola_quiz/core/common/widgets/image_gradient_background.dart';
import 'package:pacola_quiz/core/extensions/int_extensions.dart';
import 'package:pacola_quiz/core/resources/media_resources.dart';
import 'package:pacola_quiz/src/course/domain/entities/course.dart';
import 'package:pacola_quiz/src/course/features/materials/presentation/views/course_materials_view.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/views/course_quiz_view.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen(this.course, {super.key});

  static const routeName = '/course-details';

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(course.title)),
      body: ImageGradientBackground(
        image: MediaRes.homeGradientBackground,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .3,
                child: Center(
                  child: course.image != null
                      ? Image.network(course.image!)
                      : Image.asset(MediaRes.casualMeditation),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (course.description != null)
                    ExpandableText(context, text: course.description!),
                  if (course.numberOfMaterials > 0 ||
                       course.numberOfQuizzes > 0) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Subject Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (course.numberOfQuizzes > 0) ...[
                      const SizedBox(height: 10),
                      CourseInfoTile(
                        image: MediaRes.courseInfoExam,
                        title: '${course.numberOfQuizzes} Exam(s)',
                        subtitle: 'Take our exams for ${course.title}',
                        onTap: () => Navigator.of(context).pushNamed(
                          CourseQuizzesView.routeName,
                          arguments: course,
                        ),
                      ),
                    ],
                    if (course.numberOfMaterials > 0) ...[
                      const SizedBox(height: 10),
                      CourseInfoTile(
                        image: MediaRes.courseInfoMaterial,
                        title: '${course.numberOfMaterials} Material(s)',
                        subtitle: 'Access to '
                            '${course.numberOfMaterials.estimate} materials '
                            'for ${course.title}',
                        onTap: () => Navigator.of(context).pushNamed(
                          CourseMaterialsView.routeName,
                          arguments: course,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
