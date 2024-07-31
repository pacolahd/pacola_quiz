import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacola_quiz/core/common/widgets/course_info_tile.dart';
import 'package:pacola_quiz/core/common/widgets/image_gradient_background.dart';
import 'package:pacola_quiz/core/common/widgets/rounded_button.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';
import 'package:pacola_quiz/core/extensions/int_extensions.dart';
import 'package:pacola_quiz/core/resources/media_resources.dart';
import 'package:pacola_quiz/core/resources/theme/app_colors.dart';
import 'package:pacola_quiz/core/utils/core_utils.dart';
import 'package:pacola_quiz/src/course/features/quizzes/data/models/quiz_model.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/app/cubit/quiz_cubit.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/app/cubit/quiz_state.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/views/exam_view.dart';

class QuizDetailsView extends StatefulWidget {
  const QuizDetailsView(this.quiz, {super.key});

  static const routeName = '/quiz-details';

  final Quiz quiz;

  @override
  State<QuizDetailsView> createState() => _QuizDetailsViewState();
}

class _QuizDetailsViewState extends State<QuizDetailsView> {
  late Quiz completeQuiz;

  void getQuestions() {
    context.read<QuizCubit>().getQuizQuestions(widget.quiz);
  }

  @override
  void initState() {
    completeQuiz = widget.quiz;
    super.initState();
    getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(widget.quiz.title)),
      body: ImageGradientBackground(
        image: MediaRes.documentsGradientBackground,
        child: BlocConsumer<QuizCubit, QuizState>(
          listener: (_, state) {
            if (state is QuizError) {
              CoreUtils.showSnackBar(context, state.message);
            } else if (state is QuizQuestionsLoaded) {
              completeQuiz = (completeQuiz as QuizModel).copyWith(
                questions: state.questions,
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Center(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.ui.darkBlue,
                              ),
                              child: Center(
                                child: completeQuiz.imageUrl != null
                                    ? Image.network(
                                        completeQuiz.imageUrl!,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        MediaRes.test,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            completeQuiz.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            completeQuiz.description,
                            style: TextStyle(
                              color: AppColors.textColor.lightPrimary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CourseInfoTile(
                            image: MediaRes.quizTime,
                            title:
                                '${completeQuiz.timeLimit.displayDurationLong}'
                                ' for the test.',
                            subtitle: 'Complete the test in '
                                '${completeQuiz.timeLimit.displayDurationLong}',
                          ),
                          if (state is QuizQuestionsLoaded) ...[
                            const SizedBox(height: 10),
                            CourseInfoTile(
                              image: MediaRes.quizQuestions,
                              title: '${completeQuiz.questions?.length} '
                                  'Questions',
                              subtitle: 'This test consists of '
                                  '${completeQuiz.questions?.length} questions',
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (state is GettingQuizQuestions)
                      const Center(child: LinearProgressIndicator())
                    else if (state is QuizQuestionsLoaded)
                      RoundedButton(
                        label: 'Start Quiz',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            QuizView.routeName,
                            arguments: completeQuiz,
                          );
                        },
                      )
                    else
                      Text(
                        'No Questions for this quiz',
                        style: context.theme.textTheme.titleLarge,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
