import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacola_quiz/core/common/views/loading_view.dart';
import 'package:pacola_quiz/core/common/widgets/image_gradient_background.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';
import 'package:pacola_quiz/core/resources/media_resources.dart';
import 'package:pacola_quiz/core/resources/theme/app_colors.dart';
import 'package:pacola_quiz/src/auth/presentation/views/sign_in_screen.dart';
import 'package:pacola_quiz/src/auth/presentation/views/sign_up_screen.dart';
import 'package:pacola_quiz/src/on_boarding/domain/entities/page_content.dart';
import 'package:pacola_quiz/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:pacola_quiz/src/on_boarding/presentation/widgets/on_boarding_body.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OnBoardingCubit>().checkIfUserIsFirstTimer();
  }

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ImageGradientBackground(
        image: MediaRes.onBoardingBackground,
        child: BlocConsumer<OnBoardingCubit, OnBoardingState>(
          listener: (context, state) {
            // if (state is OnBoardingStatus && !state.isFirstTimer) {
            //   Navigator.pushReplacementNamed(context, Dashboard.routeName);
            // } else if (state is UserCached) {
            //   Navigator.pushReplacementNamed(context, '/');
            // }
          },
          builder: (context, state) {
            if (state is CheckingIfUserIsFirstTimer ||
                state is CachingFirstTimer) {
              return const LoadingView();
            }
            return Column(
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
                        alignment: const Alignment(0, .80),
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
                            dotHeight: 8,
                            dotWidth: 8,
                            spacing: 20,
                            activeDotColor: context.theme.colorScheme.primary,
                            dotColor: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                            const TextSpan(
                                text: 'By signing up, you agree to the '),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // TODO: Navigate to Terms and Conditions
                                },
                            ),
                            const TextSpan(text: ' and the '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // TODO: Navigate to Privacy Policy
                                },
                            ),
                            const TextSpan(text: ' of Pacola Quiz.'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: context.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.ui.darkBlue, // Dark blue
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize:
                              Size(double.infinity, context.height * 0.07),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(8),
                          //   side: BorderSide(
                          //     color: context.theme.colorScheme.primary,
                          //   ),
                        ),
                        onPressed: () {
                          context.read<OnBoardingCubit>().cacheFirstTimer();
                          Navigator.pushNamed(
                            context,
                            SignUpScreen.routeName,
                          );
                        },
                        child: const Text('Sign up for free'),
                      ),
                    ),
                    SizedBox(height: context.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.ui.darkBlue, // Dark blue
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.white,
                          minimumSize:
                              Size(double.infinity, context.height * 0.07),
                        ),
                        onPressed: () {
                          context.read<OnBoardingCubit>().cacheFirstTimer();
                          Navigator.pushNamed(
                            context,
                            SignInScreen.routeName,
                          );
                        },
                        child: const Text('or Log in'),
                      ),
                    ),
                    SizedBox(height: context.height * 0.09),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
