import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacola_quiz/core/resources/media_resources.dart';
import 'package:pacola_quiz/core/utils/core_utils.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/app/cubit/quiz_cubit.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/app/cubit/quiz_state.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/app/providers/quiz_controller.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/widgets/quiz_navigation_blob.dart';
import 'package:provider/provider.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  static const routeName = '/exam';

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  bool showingLoader = false;

  late QuizController examController;

  Future<void> submitQuiz() async {
    if (!examController.isTimeUp) {
      examController.stopTimer();
      final isMinutesLeft = examController.remainingTimeInSeconds > 60;
      final isHoursLeft = examController.remainingTimeInSeconds > 3600;
      final timeLeftText = isHoursLeft
          ? 'hours'
          : isMinutesLeft
              ? 'minutes'
              : 'seconds';

      final endQuiz = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            title: const Text('Submit Quiz?'),
            content: Text(
              'You have ${examController.remainingTime} $timeLeftText left.\n'
              'Are you sure you want to submit?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
      if (endQuiz ?? false) {
        return collectAndSend();
      } else {
        examController.startTimer();
        return;
      }
    }
    collectAndSend();
  }

  void collectAndSend() {
    final exam = examController.userQuiz;
    context.read<QuizCubit>().submitQuiz(exam);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    examController = context.read<QuizController>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      examController.addListener(() {
        if (examController.isTimeUp) submitQuiz();
      });
    });
  }

  @override
  void dispose() {
    examController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizController>(
      builder: (_, controller, __) {
        return BlocConsumer<QuizCubit, QuizState>(
          listener: (_, state) {
            if (showingLoader) {
              Navigator.pop(context);
              showingLoader = false;
            }
            if (state is QuizError) {
              CoreUtils.showSnackBar(context, state.message);
            } else if (state is SubmittingQuiz) {
              CoreUtils.showLoadingDialog(context);
              showingLoader = true;
            } else if (state is QuizSubmitted) {
              CoreUtils.showSnackBar(context, 'Quiz Submitted');
              Navigator.pop(context);
            }
          },
          builder: (_, state) => WillPopScope(
            onWillPop: () async {
              if (state is SubmittingQuiz) return false;
              if (controller.isTimeUp) return true;
              final result = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog.adaptive(
                    title: const Text('Exit Quiz'),
                    content:
                        const Text('Are you sure you want to Exit the quiz?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('Exit quiz'),
                      ),
                    ],
                  );
                },
              );
              return result ?? false;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(MediaRes.quizTimeRed, height: 30, width: 30),
                    const SizedBox(width: 10),
                    Text(
                      controller.remainingTime,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: submitQuiz,
                    child: const Text('Submit', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Text(
                              'Question ${controller.currentIndex + 1}',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Color(0xFF666E7A),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: const Color(0xFFC4C4C4),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Center(
                                child: controller.quiz.imageUrl == null
                                    ? Image.asset(
                                        MediaRes.test,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        controller.quiz.imageUrl!,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              controller.currentQuestion.questionText,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  controller.currentQuestion.choices.length,
                              itemBuilder: (_, index) {
                                final choice =
                                    controller.currentQuestion.choices[index];
                                return RadioListTile(
                                  value: choice.identifier,
                                  contentPadding: EdgeInsets.zero,
                                  groupValue: controller.userAnswer?.userChoice,
                                  title: Text(
                                    '${choice.identifier}. '
                                    '${choice.choiceAnswer}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    controller.answer(choice);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const QuizNavigationBlob(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
