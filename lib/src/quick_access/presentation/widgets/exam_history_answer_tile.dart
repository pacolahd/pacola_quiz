import 'package:flutter/material.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_choice.dart';

class QuizHistoryAnswerTile extends StatelessWidget {
  const QuizHistoryAnswerTile(this.answer, {required this.index, super.key});

  final UserChoice answer;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      expandedAlignment: Alignment.centerLeft,
      title: Text(
        'Question $index',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        answer.isCorrect ? 'Right' : 'Wrong',
        style: TextStyle(
          color: answer.isCorrect ? Colors.green : Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Text(
          'Your Answer: ${answer.userChoice}',
          style: TextStyle(
            color: answer.isCorrect ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
