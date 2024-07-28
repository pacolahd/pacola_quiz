import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/common/widgets/custom_loading_indicator.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      type: MaterialType.transparency,
      child: Center(
        child: CustomLoadingIndicator(),
      ),
    );
  }
}
