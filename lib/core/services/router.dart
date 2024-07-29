// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pacola_quiz/core/common/views/page_under_construction.dart';
// import 'package:pacola_quiz/core/common/views/page_under_construction.dart';
// import 'package:pacola_quiz/core/utils/constants.dart';
// import 'package:pacola_quiz/core/utils/constants.dart';
// import 'package:pacola_quiz/src/auth/presentation/bloc/auth_bloc.dart';
// import 'package:pacola_quiz/src/auth/presentation/bloc/auth_bloc.dart';
// import 'package:pacola_quiz/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
// import 'package:pacola_quiz/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
// import 'package:pacola_quiz/src/on_boarding/presentation/views/on_boarding_screen.dart';
// import 'package:pacola_quiz/src/on_boarding/presentation/views/on_boarding_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// final _supabaseClient = Supabase.instance.client;
//
// Route<dynamic> generateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case '/':
//       return _pageBuilder(
//         (context) {
//           final prefs = sl<SharedPreferences>();
//           if (prefs.getBool(kFirstTimerKey) ?? true) {
//             return BlocProvider(
//               create: (_) => sl<OnBoardingCubit>(),
//               child: const OnBoardingScreen(),
//             );
//           } else if (_supabaseClient.auth.currentUser != null) {
//             return const DashboardScreen();
//           } else {
//             return BlocProvider(
//               create: (_) => sl<AuthBloc>(),
//               child: const SignInScreen(),
//             );
//           }
//         },
//         settings: settings,
//       );
//
//     case SignInScreen.routeName:
//       return _pageBuilder(
//         (_) => BlocProvider(
//           create: (_) => sl<AuthBloc>(),
//           child: const SignInScreen(),
//         ),
//         settings: settings,
//       );
//
//     case SignUpScreen.routeName:
//       return _pageBuilder(
//         (_) => BlocProvider(
//           create: (_) => sl<AuthBloc>(),
//           child: const SignUpScreen(),
//         ),
//         settings: settings,
//       );
//
//     case DashboardScreen.routeName:
//       return _pageBuilder(
//         (_) => const DashboardScreen(),
//         settings: settings,
//       );
//
//     default:
//       return _pageBuilder(
//         (_) => const PageUnderConstruction(),
//         settings: settings,
//       );
//   }
// }
//
// PageRouteBuilder<dynamic> _pageBuilder(
//   Widget Function(BuildContext) page, {
//   required RouteSettings settings,
// }) {
//   return PageRouteBuilder(
//     settings: settings,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       return FadeTransition(opacity: animation, child: child);
//     },
//     pageBuilder: (context, animation, secondaryAnimation) => page(context),
//   );
// }
