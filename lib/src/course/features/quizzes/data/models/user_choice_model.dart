import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_choice.dart';

class UserChoiceModel extends UserChoice {
  const UserChoiceModel({
    required super.questionId,
    required super.correctChoice,
    required super.userChoice,
  });

  const UserChoiceModel.empty()
      : this(
          questionId: 'Test String',
          correctChoice: 'Test String',
          userChoice: 'Test String',
        );

  UserChoiceModel.fromMap(DataMap map)
      : this(
          questionId: map['questionId'] as String,
          correctChoice: map['correctChoice'] as String,
          userChoice: map['userChoice'] as String,
        );

  UserChoiceModel copyWith({
    String? questionId,
    String? correctChoice,
    String? userChoice,
  }) {
    return UserChoiceModel(
      questionId: questionId ?? this.questionId,
      correctChoice: correctChoice ?? this.correctChoice,
      userChoice: userChoice ?? this.userChoice,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'questionId': questionId,
      'correctChoice': correctChoice,
      'userChoice': userChoice,
    };
  }
}
