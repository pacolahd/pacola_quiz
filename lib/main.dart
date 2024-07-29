import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/common/app/providers/theme_provider.dart';
import 'package:pacola_quiz/core/resources/theme/app_theme.dart';
import 'package:pacola_quiz/core/services/injection_container.dart';
import 'package:pacola_quiz/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // ensure that the widgets binding is initialized before we call the init function
  WidgetsFlutterBinding.ensureInitialized();
  // initialize the dependency injection container
  await init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        // Add more providers here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pacola Quiz',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.watch<ThemeProvider>().themeMode,
      home: const OnBoardingScreen(),
      // onGenerateRoute: generateRoute,
    );
  }
}
