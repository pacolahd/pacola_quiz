import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';
import 'package:pacola_quiz/src/home/presentation/widgets/tinder_cards.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Text(
            'Hello\n${context.userProvider.user?.fullName}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 36,
            ),
          ),
          Positioned(
            top: context.height >= 926
                ? -25
                : context.height >= 844
                    ? -6
                    : context.height <= 800
                        ? 10
                        : 10,
            right: -14,
            child: const TinderCards(),
          ),
        ],
      ),
    );
  }
}
