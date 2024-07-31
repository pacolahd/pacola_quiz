import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacola_quiz/core/common/views/loading_view.dart';
import 'package:pacola_quiz/core/common/widgets/nested_back_button.dart';
import 'package:pacola_quiz/core/common/widgets/not_found_text.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';
import 'package:pacola_quiz/core/extensions/int_extensions.dart';
import 'package:pacola_quiz/core/utils/core_utils.dart';
import 'package:pacola_quiz/src/course/domain/entities/course.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/app/cubit/quiz_cubit.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/app/cubit/quiz_state.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/views/quiz_details_view.dart';

class CourseQuizzesView extends StatefulWidget {
  const CourseQuizzesView(this.course, {super.key});

  static const routeName = '/course-exams';

  final Course course;

  @override
  State<CourseQuizzesView> createState() => _CourseQuizzesViewState();
}

class _CourseQuizzesViewState extends State<CourseQuizzesView> {
  void getQuizzes() {
    context.read<QuizCubit>().getQuizzes(widget.course.id);
  }

  @override
  void initState() {
    super.initState();
    getQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('${widget.course.title} Quizzes'),
        leading: const NestedBackButton(),
      ),
      body: BlocConsumer<QuizCubit, QuizState>(
        listener: (_, state) {
          if (state is QuizError) {
            CoreUtils.showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is GettingQuizzes) {
            return const LoadingView();
          } else if ((state is QuizzesLoaded && state.exams.isEmpty) ||
              state is QuizError) {
            return NotFoundText(
              'No videos found for ${widget.course.title}',
            );
          } else if (state is QuizzesLoaded) {
            return SafeArea(
              child: ListView.builder(
                itemCount: state.exams.length,
                padding: const EdgeInsets.all(20),
                itemBuilder: (_, index) {
                  final exam = state.exams[index];
                  return Stack(
                    children: [
                      Card(
                        margin: const EdgeInsets.all(4).copyWith(bottom: 30),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exam.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(exam.description),
                              const SizedBox(height: 10),
                              Text(
                                exam.timeLimit.displayDuration,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.width * .2,
                            vertical: 10,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                QuizDetailsView.routeName,
                                arguments: exam,
                              );
                            },
                            child: const Text('Take Quiz'),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
