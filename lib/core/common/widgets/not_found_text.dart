import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';

class NotFoundText extends StatelessWidget {
  const NotFoundText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: context.theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.withOpacity(.5),
          ),
        ),
      ),
    );
  }
}
