import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacola_quiz/core/common/views/page_under_construction.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';
import 'package:pacola_quiz/core/services/injection_container.dart';
import 'package:pacola_quiz/core/utils/constants.dart';
import 'package:pacola_quiz/src/auth/data/models/user_model.dart';
import 'package:pacola_quiz/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:pacola_quiz/src/auth/presentation/views/email_login_screen.dart';
import 'package:pacola_quiz/src/auth/presentation/views/email_sign_up.dart';
import 'package:pacola_quiz/src/auth/presentation/views/forgot_password_screen.dart';
import 'package:pacola_quiz/src/auth/presentation/views/sign_in_screen.dart';
import 'package:pacola_quiz/src/auth/presentation/views/sign_up_screen.dart';
import 'package:pacola_quiz/src/course/domain/entities/course.dart';
import 'package:pacola_quiz/src/course/features/materials/presentation/app/cubit/material_cubit.dart';
import 'package:pacola_quiz/src/course/features/materials/presentation/views/add_materials_view.dart';
import 'package:pacola_quiz/src/course/features/materials/presentation/views/course_materials_view.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/app/cubit/quiz_cubit.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/app/providers/quiz_controller.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/views/add_quiz_view.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/views/course_quiz_view.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/views/exam_view.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/views/quiz_details_view.dart';
import 'package:pacola_quiz/src/course/presentation/bloc/course_cubit.dart';
import 'package:pacola_quiz/src/course/presentation/views/course_details_screen.dart';
import 'package:pacola_quiz/src/dashboard/presentation/views/dashboard.dart';
import 'package:pacola_quiz/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:pacola_quiz/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:pacola_quiz/src/quick_access/presentation/views/exam_history_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      // We can access all shared preferences here (even without needing to await) because we have already initialized the dependency injection container and we waited for it during the initialisation of the app.
      final prefs = sl<SharedPreferences>();
      return _pageBuilder(
        (context) {
          // If the user is a first timer, we want to push to the onBoardingScreen
          if (prefs.getBool(kFirstTimerKey) ?? true) {
            // We're injecting the cubit here because we want it to be available only to the OnBoardingScreen, and not to the entire app.
            return BlocProvider(
              create: (_) => sl<OnBoardingCubit>(),
              child: const OnBoardingScreen(),
            );
          }
          // If the user is already loggedIn, we want to push to the home screen
          // While doing so we also want to pass the userData to the home screen
          else if (sl<FirebaseAuth>().currentUser != null) {
            final user = sl<FirebaseAuth>().currentUser!;
            debugPrint('User Hmm: $user');
            final localUser = UserModel(
              id: user.uid,
              email: user.email ?? '',
              fullName: user.displayName ?? '',
              profilePic: user.photoURL,
            );
            // Assuming you have a userProvider in your context
            context.userProvider.initUser(localUser);
            debugPrint('Inited User: $user');
            return const Dashboard();
          }

          // // If the user is not a first timer and not logged in, we want to push to the login screen (assuming they were logged in and just logged out)
          // return BlocProvider(
          //   create: (_) => sl<AuthBloc>(),
          //   child: const SignInScreen(),
          // );

          // If the user is not a first timer and not logged in, we want to push to the onboarding screen so that they can either login or signup
          // Maybe the user was logged in and then logged out for another user to create an account. This handles that gracefully
          return BlocProvider(
            create: (_) => sl<OnBoardingCubit>(),
            child: const OnBoardingScreen(),
          );
        },
        settings: settings,
      );

    case SignInScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignInScreen(),
        ),
        settings: settings,
      );

    case EmailLogInScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const EmailLogInScreen(),
        ),
        settings: settings,
      );

    case EmailSignUpScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const EmailSignUpScreen(),
        ),
        settings: settings,
      );

    case SignUpScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignUpScreen(),
        ),
        settings: settings,
      );
    case ForgotPasswordScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const ForgotPasswordScreen(),
        ),
        settings: settings,
      );

    case Dashboard.routeName:
      return _pageBuilder(
        (_) => const Dashboard(),
        settings: settings,
      );

    case CourseDetailsScreen.routeName:
      return _pageBuilder(
        (_) => CourseDetailsScreen(settings.arguments! as Course),
        settings: settings,
      );
    case QuizDetailsView.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (context) => sl<QuizCubit>(),
          child: QuizDetailsView(settings.arguments! as Quiz),
        ),
        settings: settings,
      );
    case QuizHistoryDetailsScreen.routeName:
      return _pageBuilder(
        (_) => QuizHistoryDetailsScreen(settings.arguments! as UserQuiz),
        settings: settings,
      );
    case QuizView.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (context) => sl<QuizCubit>(),
          child: ChangeNotifierProvider(
            create: (context) => QuizController(
              quiz: settings.arguments! as Quiz,
            ),
            child: const QuizView(),
          ),
        ),
        settings: settings,
      );

    case AddMaterialsView.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<CourseCubit>()),
            BlocProvider(create: (_) => sl<MaterialCubit>()),
          ],
          child: const AddMaterialsView(),
        ),
        settings: settings,
      );
    case AddQuizView.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<CourseCubit>()),
            BlocProvider(create: (_) => sl<QuizCubit>()),
          ],
          child: const AddQuizView(),
        ),
        settings: settings,
      );

    case CourseMaterialsView.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<MaterialCubit>(),
          child: CourseMaterialsView(settings.arguments! as Course),
        ),
        settings: settings,
      );
    case CourseQuizzesView.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<QuizCubit>(),
          child: CourseQuizzesView(settings.arguments! as Course),
        ),
        settings: settings,
      );

    default:
      return _pageBuilder(
        (_) => const PageUnderConstruction(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    pageBuilder: (context, animation, secondaryAnimation) => page(context),
  );
}
