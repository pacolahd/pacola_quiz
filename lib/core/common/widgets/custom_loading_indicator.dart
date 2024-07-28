import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SpinKitPouringHourGlassRefined(
      color: context.theme.colorScheme.secondary,
      size: 50,
    );
  }
}
