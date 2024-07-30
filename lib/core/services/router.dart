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
import 'package:pacola_quiz/src/dashboard/presentation/views/dashboard.dart';
import 'package:pacola_quiz/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:pacola_quiz/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabaseClient = Supabase.instance.client;

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
          else if (sl<SupabaseClient>().auth.currentUser != null) {
            final user = sl<SupabaseClient>().auth.currentUser!;
            final localUser = UserModel(
              id: user.id,
              email: user.email ?? '',
              firstName: user.userMetadata?['first_name'] as String ?? '',
              lastName: user.userMetadata?['last_name'] as String ?? '',
              profilePic: user.userMetadata?['avatar_url'] as String ?? '',
            );
            // Assuming you have a userProvider in your context
            context.userProvider.initUser(localUser);
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
