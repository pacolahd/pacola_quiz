import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pacola_quiz/core/common/widgets/image_gradient_background.dart';
import 'package:pacola_quiz/core/resources/media_resources.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ImageGradientBackground(
        image: MediaRes.onBoardingBackground,
        child: Center(child: Lottie.asset(MediaRes.pageUnderConstruction)),
      ),
    );
  }
}
