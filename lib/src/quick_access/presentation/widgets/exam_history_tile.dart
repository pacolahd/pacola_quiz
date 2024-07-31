import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/resources/media_resources.dart';
import 'package:pacola_quiz/core/resources/theme/app_colors.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_quiz.dart';
import 'package:pacola_quiz/src/quick_access/presentation/views/exam_history_details_screen.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class QuizHistoryTile extends StatelessWidget {
  const QuizHistoryTile(
    this.quiz, {
    super.key,
    this.navigateToDetails = true,
  });

  final UserQuiz quiz;
  final bool navigateToDetails;

  @override
  Widget build(BuildContext context) {
    final answeredQuestionsPercentage =
        quiz.answers.length / quiz.totalQuestions;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: navigateToDetails
          ? () => Navigator.of(context).pushNamed(
                QuizHistoryDetailsScreen.routeName,
                arguments: quiz,
              )
          : null,
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.brand.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: quiz.quizImageUrl == null
                ? Image.asset(MediaRes.test)
                : Image.network(quiz.quizImageUrl!),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.quizTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'You have completed',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: '${quiz.answers.length}/${quiz.totalQuestions} ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: answeredQuestionsPercentage < .5
                          ? Colors.red
                          : Colors.green,
                    ),
                    children: const [
                      TextSpan(
                        text: 'questions',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CircularStepProgressIndicator(
            totalSteps: quiz.totalQuestions,
            currentStep: quiz.answers.length,
            selectedColor:
                answeredQuestionsPercentage < .5 ? Colors.red : Colors.green,
            padding: 0,
            width: 60,
            height: 60,
            child: Center(
              child: Text(
                '${(answeredQuestionsPercentage * 100).toInt()}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: answeredQuestionsPercentage < .5
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
