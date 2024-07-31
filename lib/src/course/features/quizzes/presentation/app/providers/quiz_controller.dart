import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pacola_quiz/src/course/features/quizzes/data/models/user_choice_model.dart';
import 'package:pacola_quiz/src/course/features/quizzes/data/models/user_quiz_model.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/question_choice.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz_question.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_choice.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_quiz.dart';

class QuizController extends ChangeNotifier {
  QuizController({required Quiz quiz})
      : _quiz = quiz,
        _questions = quiz.questions! {
    _userQuiz = UserQuizModel(
      quizId: quiz.id,
      courseId: quiz.courseId,
      answers: const [],
      quizTitle: quiz.title,
      quizImageUrl: quiz.imageUrl,
      totalQuestions: quiz.questions!.length,
      dateSubmitted: DateTime.now(),
      score: 0,
    );
    _remainingTime = quiz.timeLimit;
  }

  final Quiz _quiz;

  Quiz get quiz => _quiz;

  final List<QuizQuestion> _questions;

  int get totalQuestions => _questions.length;

  late UserQuiz _userQuiz;

  UserQuiz get userQuiz => _userQuiz;

  late int _remainingTime;

  bool get isTimeUp => _remainingTime == 0;
  bool _quizStarted = false;

  bool get quizStarted => _quizStarted;

  Timer? _timer;

  String get remainingTime {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  int get remainingTimeInSeconds => _remainingTime;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  QuizQuestion get currentQuestion => _questions[_currentIndex];

  void startTimer() {
    _quizStarted = true;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_remainingTime > 0) {
          _remainingTime--;
          notifyListeners();
        } else {
          timer.cancel();
        }
      },
    );
  }

  void stopTimer() {
    _timer?.cancel();
  }

  UserChoice? get userAnswer {
    final answers = _userQuiz.answers;
    var noAnswer = false;
    final questionId = currentQuestion.id;
    final userChoice = answers.firstWhere(
      (answer) => answer.questionId == questionId,
      orElse: () {
        noAnswer = true;
        return const UserChoiceModel.empty();
      },
    );
    return noAnswer ? null : userChoice;
  }

  void changeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void nextQuestion() {
    if (!_quizStarted) startTimer();
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void answer(QuestionChoice choice) {
    if (!_quizStarted && currentIndex == 0) startTimer();
    final answers = List<UserChoice>.of(_userQuiz.answers);
    final userChoice = UserChoiceModel(
      questionId: choice.questionId,
      correctChoice: currentQuestion.correctAnswer!,
      userChoice: choice.identifier,
    );
    if (answers.any((answer) => answer.questionId == userChoice.questionId)) {
      final index = answers.indexWhere(
        (answer) => answer.questionId == userChoice.questionId,
      );
      answers[index] = userChoice;
    } else {
      answers.add(userChoice);
    }
    _userQuiz = (_userQuiz as UserQuizModel).copyWith(
      answers: answers,
      score: calculateScore(answers),
    );
    notifyListeners();
  }

  int calculateScore(List<UserChoice> answers) {
    int correctAnswers = answers.where((answer) => answer.isCorrect).length;
    return (correctAnswers / totalQuestions * 100).round();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
