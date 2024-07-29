import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentIndex = 0;

  final List<String> _features = [
    'AI Tools',
    'Mock Exams',
    'Study plan',
    'Explanations',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(Duration(seconds: 3), () {
      _animationController.forward(from: 0.0).then((_) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _features.length;
        });
        _animationController.reset();
        _startAnimation();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.theme.colorScheme.primary,
              context.theme.colorScheme.primary.withOpacity(0.7),
              Colors.white,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.school, color: Colors.white, size: 48),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'English (UK)',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_drop_down, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                SizedBox(
                  height: 200,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(_features.length, (index) {
                          final relativeIndex =
                              (index - _currentIndex + _features.length) %
                                  _features.length;
                          final offset =
                              relativeIndex - (_features.length ~/ 2);
                          final t = 1 - _animation.value;
                          final translateY = offset * 60.0 +
                              (relativeIndex == _features.length - 1
                                  ? -60 * t
                                  : 0);
                          final opacity =
                              relativeIndex == (_features.length ~/ 2)
                                  ? 1.0
                                  : 0.5;

                          return Expanded(
                            child: Transform.translate(
                              offset: Offset(0, translateY),
                              child: Opacity(
                                opacity: opacity,
                                child: Text(
                                  _features[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
                Spacer(),
                Text(
                  'All the tools for\nlearning success.',
                  style: TextStyle(
                    color: context.theme.colorScheme.onPrimary,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                Text(
                  'In one app.',
                  style: TextStyle(
                    color: context.theme.colorScheme.secondary,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement get started functionality
                  },
                  child: Text('Get started for free',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: context.theme.colorScheme.primary,
                    backgroundColor: context.theme.colorScheme.onPrimary,
                    minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Implement login functionality
                  },
                  child: Text('Already have an account',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.theme.colorScheme.primary,
                    side: BorderSide(
                        color: context.theme.colorScheme.primary, width: 2),
                    minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
