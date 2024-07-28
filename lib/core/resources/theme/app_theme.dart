import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.brand.primary,
      onPrimary: Colors.white,
      secondary: AppColors.brand.secondary,
      onSecondary: Colors.white,
      error: AppColors.feedback.error,
      onError: Colors.white,
      surface: AppColors.background.surface,
      onSurface: AppColors.textColor.primary,
      surfaceTint: AppColors.brand.primary,
      surfaceContainerHighest: AppColors.background.main,
      onSurfaceVariant: AppColors.textColor.secondary,
    ),
    scaffoldBackgroundColor: AppColors.background.main,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.brand.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: appTextTheme.titleLarge?.copyWith(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brand.primary,
        foregroundColor: Colors.white,
        textStyle: quizTextTheme.buttonText,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.brand.primary,
        side: BorderSide(color: AppColors.brand.primary),
        textStyle: quizTextTheme.buttonText,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.brand.primary,
        textStyle: quizTextTheme.buttonText,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.background.card,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.background.surface,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.ui.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.brand.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.feedback.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.feedback.error, width: 2),
      ),
      labelStyle: appTextTheme.bodyMedium,
      hintStyle: appTextTheme.bodyMedium?.copyWith(
        color: AppColors.textColor.hint,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.ui.divider,
      thickness: 1,
      space: 24,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.brand.primary,
      unselectedItemColor: AppColors.textColor.secondary,
      selectedLabelStyle: appTextTheme.labelSmall,
      unselectedLabelStyle: appTextTheme.labelSmall,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    textTheme: TextTheme(
      displayLarge: appTextTheme.displayLarge,
      displayMedium: appTextTheme.displayMedium,
      displaySmall: appTextTheme.displaySmall,
      headlineLarge: appTextTheme.headlineLarge,
      headlineMedium: appTextTheme.headlineMedium,
      headlineSmall: appTextTheme.headlineSmall,
      titleLarge: appTextTheme.titleLarge,
      titleMedium: appTextTheme.titleMedium,
      titleSmall: appTextTheme.titleSmall,
      bodyLarge: appTextTheme.bodyLarge,
      bodyMedium: appTextTheme.bodyMedium,
      bodySmall: appTextTheme.bodySmall,
      labelLarge: appTextTheme.labelLarge,
      labelMedium: appTextTheme.labelMedium,
      labelSmall: appTextTheme.labelSmall,
    ),
    extensions: [quizTextTheme],
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.brand.primary,
      onPrimary: Colors.white,
      secondary: AppColors.brand.secondary,
      onSecondary: Colors.white,
      error: AppColors.feedback.error,
      onError: Colors.white,
      surface: AppColors.shade.black54,
      onSurface: Colors.white,
      surfaceTint: AppColors.brand.primary,
      surfaceContainerHighest: AppColors.shade.black87,
      onSurfaceVariant: Colors.white70,
    ),
    scaffoldBackgroundColor: AppColors.shade.black87,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.shade.black87,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: appTextTheme.titleLarge?.copyWith(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brand.primary,
        foregroundColor: Colors.white,
        textStyle: quizTextTheme.buttonText,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.brand.primary,
        side: BorderSide(color: AppColors.brand.primary),
        textStyle: quizTextTheme.buttonText,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.brand.primary,
        textStyle: quizTextTheme.buttonText,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.shade.black54,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.shade.black54,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.ui.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.brand.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.feedback.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.feedback.error, width: 2),
      ),
      labelStyle: appTextTheme.bodyMedium?.copyWith(color: Colors.white),
      hintStyle: appTextTheme.bodyMedium?.copyWith(
        color: AppColors.textColor.hint,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.ui.divider,
      thickness: 1,
      space: 24,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.shade.black87,
      selectedItemColor: AppColors.brand.primary,
      unselectedItemColor: Colors.white70,
      selectedLabelStyle:
          appTextTheme.labelSmall?.copyWith(color: Colors.white),
      unselectedLabelStyle:
          appTextTheme.labelSmall?.copyWith(color: Colors.white70),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    textTheme: TextTheme(
      displayLarge: appTextTheme.displayLarge?.copyWith(color: Colors.white),
      displayMedium: appTextTheme.displayMedium?.copyWith(color: Colors.white),
      displaySmall: appTextTheme.displaySmall?.copyWith(color: Colors.white),
      headlineLarge: appTextTheme.headlineLarge?.copyWith(color: Colors.white),
      headlineMedium:
          appTextTheme.headlineMedium?.copyWith(color: Colors.white),
      headlineSmall: appTextTheme.headlineSmall?.copyWith(color: Colors.white),
      titleLarge: appTextTheme.titleLarge?.copyWith(color: Colors.white),
      titleMedium: appTextTheme.titleMedium?.copyWith(color: Colors.white),
      titleSmall: appTextTheme.titleSmall?.copyWith(color: Colors.white),
      bodyLarge: appTextTheme.bodyLarge?.copyWith(color: Colors.white),
      bodyMedium: appTextTheme.bodyMedium?.copyWith(color: Colors.white),
      bodySmall: appTextTheme.bodySmall?.copyWith(color: Colors.white70),
      labelLarge: appTextTheme.labelLarge?.copyWith(color: Colors.white),
      labelMedium: appTextTheme.labelMedium?.copyWith(color: Colors.white),
      labelSmall: appTextTheme.labelSmall?.copyWith(color: Colors.white),
    ),
    extensions: [
      quizTextTheme.copyWith(
        quizTitle: quizTextTheme.quizTitle?.copyWith(color: Colors.white),
        quizQuestion: quizTextTheme.quizQuestion?.copyWith(color: Colors.white),
        quizAnswer: quizTextTheme.quizAnswer?.copyWith(color: Colors.white),
        quizExplanation:
            quizTextTheme.quizExplanation?.copyWith(color: Colors.white70),
        scoreText:
            quizTextTheme.scoreText?.copyWith(color: AppColors.brand.primary),
        timerText:
            quizTextTheme.timerText?.copyWith(color: AppColors.accent.orange),
      ),
    ],
  );
}
