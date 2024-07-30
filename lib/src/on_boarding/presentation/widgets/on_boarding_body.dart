import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';
import 'package:pacola_quiz/src/on_boarding/domain/entities/page_content.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({required this.pageContent, super.key});

  final PageContent pageContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(pageContent.image, height: context.height * .27),
        SizedBox(height: context.height * .03),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width * 0.07),
          child: Text(
            pageContent.title,
            textAlign: TextAlign.center,
            style: context.theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.onBackground,
            ),
          ),
        ),
      ],
    );
  }
}
