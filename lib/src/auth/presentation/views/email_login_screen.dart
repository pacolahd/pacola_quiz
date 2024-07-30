import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pacola_quiz/core/common/widgets/custom_form_builder_titled_text_field.dart';
import 'package:pacola_quiz/core/common/widgets/image_gradient_background.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';
import 'package:pacola_quiz/core/resources/media_resources.dart';
import 'package:pacola_quiz/core/resources/theme/app_colors.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({Key? key}) : super(key: key);

  static const routeName = '/email-login';

  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  bool _obscurePassword = true;
  final _loginFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ImageGradientBackground(
        image: MediaRes.authGradientBackground,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: context.height * 0.1),
                Center(
                  child: Image.asset(
                    MediaRes.schoolQuiz, // Replace with your app logo
                    height: context.height * 0.1,
                  ),
                ),
                SizedBox(height: context.height * 0.04),
                Text(
                  'Log in with email',
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.height * 0.03),
                SizedBox(height: context.height * 0.01),
                FormBuilder(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      const CustomFormBuilderTitledTextField(
                        title: 'Email',
                        name: 'email',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        suffixIcon: Icon(
                          HugeIcons.strokeRoundedMail01,
                        ),
                      ),
                      SizedBox(height: context.height * 0.02),
                      SizedBox(height: context.height * 0.01),
                      CustomFormBuilderTitledTextField(
                        obscureText: _obscurePassword,
                        title: 'Password',
                        name: 'password',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: context.height * 0.02),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text(
                            'Forgot your password?',
                            style: TextStyle(color: AppColors.ui.darkBlue),
                          ),
                          onPressed: () {
                            // TODO: Implement forgot password functionality
                          },
                        ),
                      ),
                      SizedBox(height: context.height * 0.04),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.ui.darkBlue,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Log in'),
                        onPressed: () {
                          // TODO: Implement login functionality
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
