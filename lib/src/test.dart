import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Image.network(
                context.userProvider.user?.profilePic ?? '',
                height: context.height * 0.3,
              ),
              Text(context.userProvider.user?.fullName ?? 'No email'),
              Text('Test'),
            ],
          ),
        ),
      ),
    );
  }
}
