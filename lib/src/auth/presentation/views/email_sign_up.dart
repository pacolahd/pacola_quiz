import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pacola_quiz/core/common/widgets/custom_form_builder_titled_text_field.dart';
import 'package:pacola_quiz/core/common/widgets/image_gradient_background.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';
import 'package:pacola_quiz/core/resources/media_resources.dart';
import 'package:pacola_quiz/core/resources/theme/app_colors.dart';
import 'package:pacola_quiz/core/utils/core_utils.dart';
import 'package:pacola_quiz/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:pacola_quiz/src/auth/presentation/views/email_login_screen.dart';

class EmailSignUpScreen extends StatefulWidget {
  const EmailSignUpScreen({Key? key}) : super(key: key);

  static const routeName = '/email-sign-up';

  @override
  _EmailSignUpScreenState createState() => _EmailSignUpScreenState();
}

class _EmailSignUpScreenState extends State<EmailSignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;
  final _signUpFormKey = GlobalKey<FormBuilderState>();

  bool _hasMinLength = false;
  bool _hasLetter = false;
  bool _hasNumberOrSpecialChar = false;
  bool _passwordTouched = false;
  bool _reverseScrollDirection = false;

  // void dispose() {
  //   super.dispose();
  //   CoreUtils.unfocusAllFields(context);
  //  }
  //
  // void initState() {
  //   super.initState();
  //   _signUpFormKey.currentState?.reset();
  // }

  void _updatePasswordCriteria(String? value) {
    setState(() {
      _passwordTouched = true;
      _hasMinLength = value!.length >= 8;
      _hasLetter = value.contains(RegExp(r'[a-zA-Z]'));
      _hasNumberOrSpecialChar =
          value.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'));
    });
  }

  String? noNumericChars(String? value,
      {String errorText = 'No numbers allowed'}) {
    final regex = RegExp(r'[0-9]');
    if (regex.hasMatch(value ?? '')) {
      return errorText;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            CoreUtils.showLoadingDialog(context);
          } else {
            // Dismiss the loading dialog if it's showing
            Navigator.of(context).popUntil((route) => route is! DialogRoute);

            if (state is AuthError) {
              CoreUtils.showMessageDialog(
                context,
                title: 'Error',
                message: state.message,
                type: MessageType.error,
              );
            } else if (state is SignedUp) {
              Navigator.pushReplacementNamed(
                context,
                EmailLogInScreen.routeName,
              );
            }
          }
        },
        builder: (context, state) {
          // if (state is AuthLoading) {
          //   return const Center(child: LoadingView());
          // }
          return ImageGradientBackground(
            image: MediaRes.onBoardingBackground,
            child: Stack(
              children: [
                SingleChildScrollView(
                  reverse: _reverseScrollDirection,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: context.height * 0.05),
                        Center(
                          child: Image.asset(
                            MediaRes.schoolQuiz,
                            height: context.height * 0.1,
                          ),
                        ),
                        SizedBox(height: context.height * 0.02),
                        Text(
                          'Sign up with email',
                          style:
                              context.theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: context.height * 0.02),
                        FormBuilder(
                          key: _signUpFormKey,
                          child: Column(
                            children: [
                              CustomFormBuilderTitledTextField(
                                title: 'Name',
                                name: 'name',
                                // contentPadding: const EdgeInsets.symmetric(
                                //     horizontal: 20, vertical: 20),
                                // suffixIcon: const Icon(
                                //     Icons),
                                validators: [
                                  FormBuilderValidators.minLength(
                                    3,
                                    errorText: 'Must be > 2 characters',
                                  ),
                                  noNumericChars,
                                ],
                              ),
                              SizedBox(width: context.height * 0.02),
                              SizedBox(height: context.height * 0.015),
                              CustomFormBuilderTitledTextField(
                                title: 'Email',
                                name: 'email',
                                // contentPadding: const EdgeInsets.symmetric(
                                //     horizontal: 20, vertical: 20),
                                suffixIcon:
                                    const Icon(HugeIcons.strokeRoundedMail01),
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText: 'Email is required'),
                                  FormBuilderValidators.email(
                                      errorText: 'Please enter a valid email'),
                                ],
                              ),
                              SizedBox(height: context.height * 0.015),
                              CustomFormBuilderTitledTextField(
                                obscureText: _obscurePassword,
                                title: 'Password',
                                name: 'password',
                                // contentPadding: const EdgeInsets.symmetric(
                                //     horizontal: 20, vertical: 20),
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
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText: 'Password is required'),
                                  (value) {
                                    if (value == null || value.isEmpty)
                                      return null;
                                    if (!_hasMinLength)
                                      return 'Password must be at least 8 characters long';
                                    if (!_hasLetter)
                                      return 'Password must contain at least one letter';
                                    if (!_hasNumberOrSpecialChar)
                                      return 'Password must contain at least one number or special character';
                                    return null;
                                  },
                                ],
                                onChanged: _updatePasswordCriteria,
                                onTap: () {
                                  setState(() {
                                    _reverseScrollDirection = true;
                                  });
                                },
                                additionalTapOutside: () {
                                  setState(() {
                                    _reverseScrollDirection = false;
                                  });
                                },
                              ),
                              SizedBox(height: context.height * 0.01),
                              _buildPasswordCriteria(),
                              SizedBox(height: context.height * 0.015),
                              CustomFormBuilderTitledTextField(
                                obscureText: _obscureRepeatPassword,
                                isRepeatPassword: true,
                                title: 'Repeat Password',
                                name: 'repeatPassword',
                                // contentPadding: const EdgeInsets.symmetric(
                                //     horizontal: 20, vertical: 20),
                                hintText: 'Repeat your password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureRepeatPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureRepeatPassword =
                                          !_obscureRepeatPassword;
                                    });
                                  },
                                ),
                                required: false,
                                validators: [
                                  // FormBuilderValidators.required(
                                  //     errorText: 'Please repeat your password'),
                                  (value) {
                                    if (value !=
                                        _signUpFormKey.currentState
                                            ?.fields['password']?.value) {
                                      return 'Passwords don\'t match';
                                    }
                                    if (_signUpFormKey.currentState
                                            ?.fields['password']?.value ==
                                        null) return null;
                                    return null;
                                  },
                                ],
                              ),
                              SizedBox(height: context.height * 0.02),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColors.ui.darkBlue,
                                  minimumSize: Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Sign up'),
                                onPressed: () {
                                  CoreUtils.unfocusAllFields(context);
                                  if (_signUpFormKey.currentState
                                          ?.saveAndValidate() ??
                                      false) {
                                    final data =
                                        _signUpFormKey.currentState?.value;
                                    if (data != null) {
                                      context.read<AuthBloc>().add(
                                            SignUpEvent(
                                              email: data['email'] as String,
                                              password:
                                                  data['password'] as String,
                                              fullName: data['name'] as String,
                                            ),
                                          );
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: context.height * 0.03),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(color: Colors.grey[600]),
                                  children: [
                                    const TextSpan(
                                        text:
                                            'By signing up, you agree to the '),
                                    TextSpan(
                                      text: 'Terms and Conditions',
                                      style:
                                          const TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // TODO: Navigate to Terms and Conditions
                                        },
                                    ),
                                    const TextSpan(text: ' and the '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style:
                                          const TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // TODO: Navigate to Privacy Policy
                                        },
                                    ),
                                    const TextSpan(text: ' of Pacola Quiz.'),
                                  ],
                                ),
                              ),
                              SizedBox(height: context.height * 0.02),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                // if (state is AuthLoading) const LoadingView(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPasswordCriteria() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Criteria', style: TextStyle(fontWeight: FontWeight.bold)),
        _criteriaItem('at least 8 characters', _hasMinLength),
        _criteriaItem('at least one letter', _hasLetter),
        _criteriaItem('at least one number or special character',
            _hasNumberOrSpecialChar),
      ],
    );
  }

  Widget _criteriaItem(String text, bool isMet) {
    Color iconColor;
    IconData iconData;

    if (!_passwordTouched) {
      iconColor = Colors.grey;
      iconData = Icons.circle;
    } else {
      iconColor = isMet ? Colors.green : Colors.red;
      iconData = isMet ? Icons.check_circle : Icons.cancel;
    }

    return Row(
      children: [
        Icon(
          iconData,
          color: iconColor,
          size: 13,
        ),
        SizedBox(width: 8),
        Text(text,
            style: TextStyle(
                fontSize: 13,
                color: _passwordTouched
                    ? (isMet ? Colors.green : Colors.red)
                    : Colors.black)),
      ],
    );
  }
}
