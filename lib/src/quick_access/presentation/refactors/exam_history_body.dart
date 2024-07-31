import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacola_quiz/core/common/views/loading_view.dart';
import 'package:pacola_quiz/core/common/widgets/not_found_text.dart';
import 'package:pacola_quiz/core/utils/core_utils.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/app/cubit/quiz_cubit.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/app/cubit/quiz_state.dart';
import 'package:pacola_quiz/src/quick_access/presentation/widgets/exam_history_tile.dart';

class QuizHistoryBody extends StatefulWidget {
  const QuizHistoryBody({super.key});

  @override
  State<QuizHistoryBody> createState() => _QuizHistoryBodyState();
}

class _QuizHistoryBodyState extends State<QuizHistoryBody> {
  void getHistory() {
    context.read<QuizCubit>().getUserQuizzes();
  }

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizCubit, QuizState>(
      listener: (_, state) {
        if (state is QuizError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is GettingUserQuizzes) {
          return const LoadingView();
        } else if ((state is UserQuizzesLoaded && state.exams.isEmpty) ||
            state is QuizError) {
          return const NotFoundText('No exams completed yet');
        } else if (state is UserQuizzesLoaded) {
          final exams = state.exams
            ..sort(
              (a, b) => b.dateSubmitted.compareTo(a.dateSubmitted),
            );
          return ListView.builder(
            itemCount: exams.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (_, index) {
              final exam = exams[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QuizHistoryTile(exam),
                  if (index != exams.length - 1) const SizedBox(height: 20),
                ],
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
