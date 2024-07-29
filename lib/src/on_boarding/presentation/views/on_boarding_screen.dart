import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/common/widgets/image_gradient_background.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';
import 'package:pacola_quiz/core/resources/media_resources.dart';
import 'package:pacola_quiz/src/on_boarding/domain/entities/page_content.dart';
import 'package:pacola_quiz/src/on_boarding/presentation/widgets/on_boarding_body.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ImageGradientBackground(
        image: MediaRes.onBoardingBackground,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Pacola Quiz',
                  style: context.theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      color: context.theme.colors.primaryDark),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: pageController,
                    children: const [
                      OnBoardingBody(pageContent: PageContent.first()),
                      OnBoardingBody(pageContent: PageContent.second()),
                      OnBoardingBody(pageContent: PageContent.third()),
                    ],
                  ),
                  Align(
                    alignment: const Alignment(0, .9),
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: 3,
                      onDotClicked: (index) {
                        pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      effect: WormEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 20,
                        activeDotColor: context.theme.colorScheme.primary,
                        dotColor: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(context.width * 0.05),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                      children: [
                        const TextSpan(
                            text: "By signing up, I accept Pacola Quiz's "),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: context.theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to Terms of Service
                            },
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: context.theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to Privacy Policy
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.height * 0.02),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, context.height * 0.06),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to sign up page
                    },
                    child: const Text('Sign up for free'),
                  ),
                  SizedBox(height: context.height * 0.02),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: context.theme.colorScheme.primary,
                      minimumSize: Size(double.infinity, context.height * 0.06),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to login page
                    },
                    child: const Text('Log in'),
                  ),
                  SizedBox(height: context.height * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
