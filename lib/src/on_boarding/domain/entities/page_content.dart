import 'package:equatable/equatable.dart';
import 'package:pacola_quiz/core/resources/media_resources.dart';

// lib/src/on_boarding/domain/entities/page_content.dart

// lib/src/on_boarding/domain/entities/page_content.dart

class PageContent extends Equatable {
  const PageContent({
    required this.image,
    required this.title,
  });

  const PageContent.first()
      : this(
          image: MediaRes.schoolQuiz, // Replace with your custom image
          title: 'Upload slides, get AI-generated quizzes',
        );

  const PageContent.second()
      : this(
          image: MediaRes.casualReading, // Replace with your custom image
          title: 'Practice with personalized flashcards',
        );

  const PageContent.third()
      : this(
          image: MediaRes
              .casualMeditationScience, // Replace with your custom image
          title: 'Track your progress and improve',
        );

  final String image;
  final String title;

  @override
  List<Object?> get props => [image, title];
}
