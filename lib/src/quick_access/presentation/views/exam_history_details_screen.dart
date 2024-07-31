import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_quiz.dart';
import 'package:pacola_quiz/src/quick_access/presentation/widgets/exam_history_answer_tile.dart';
import 'package:pacola_quiz/src/quick_access/presentation/widgets/exam_history_tile.dart';

class QuizHistoryDetailsScreen extends StatelessWidget {
  const QuizHistoryDetailsScreen(this.quiz, {super.key});

  static const routeName = '/quiz-history-details';

  final UserQuiz quiz;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('${quiz.quizTitle} Details')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuizHistoryTile(quiz, navigateToDetails: false),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'Date Submitted: ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat.yMMMMd().format(quiz.dateSubmitted),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: quiz.answers.length,
                  separatorBuilder: (_, __) => const Divider(
                    thickness: 1,
                    color: Color(0xFFE6E8EC),
                  ),
                  itemBuilder: (_, index) {
                    final answer = quiz.answers[index];
                    return QuizHistoryAnswerTile(answer, index: index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
