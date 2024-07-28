import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/resources/theme/app_colors.dart';
import 'package:pacola_quiz/core/resources/theme/app_text_theme.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;

// Uncomment and adjust these lines when you have implemented user authentication
// UserProvider get userProvider => read<UserProvider>();
// User? get currentUser => userProvider.user;
}

extension CustomThemeData on ThemeData {
  AppTextTheme get textStyles {
    return extension<AppTextTheme>() ?? const AppTextTheme();
  }

  AppColorsExtension get colors => AppColorsExtension();
}

class AppColorsExtension {
  Color get primary => AppColors.brand.primary;
  Color get primaryLight => AppColors.brand.primaryLight;
  Color get primaryDark => AppColors.brand.primaryDark;
  Color get secondary => AppColors.brand.secondary;
  Color get secondaryLight => AppColors.brand.secondaryLight;
  Color get secondaryDark => AppColors.brand.secondaryDark;

  Color get accentOrange => AppColors.accent.orange;
  Color get accentPurple => AppColors.accent.purple;
  Color get accentRed => AppColors.accent.red;

  Color get backgroundMain => AppColors.background.main;
  Color get backgroundSurface => AppColors.background.surface;
  Color get backgroundCard => AppColors.background.card;

  Color get textPrimary => AppColors.textColor.primary;
  Color get textSecondary => AppColors.textColor.secondary;
  Color get textHint => AppColors.textColor.hint;
  Color get textDisabled => AppColors.textColor.disabled;
  Color get textLink => AppColors.textColor.link;
  Color get textInversePrimary => AppColors.textColor.inversePrimary;
  Color get textInverseSecondary => AppColors.textColor.inverseSecondary;

  Color get feedbackSuccess => AppColors.feedback.success;
  Color get feedbackError => AppColors.feedback.error;
  Color get feedbackWarning => AppColors.feedback.warning;
  Color get feedbackInfo => AppColors.feedback.info;

  Color get uiDivider => AppColors.ui.divider;
  Color get uiBorder => AppColors.ui.border;
  Color get uiIconPrimary => AppColors.ui.iconPrimary;
  Color get uiIconSecondary => AppColors.ui.iconSecondary;
  Color get uiDisabled => AppColors.ui.disabled;

  Color get overlayLight => AppColors.overlay.light;
  Color get overlayDark => AppColors.overlay.dark;

  Color get shadeBlack05 => AppColors.shade.black05;
  Color get shadeBlack12 => AppColors.shade.black12;
  Color get shadeBlack26 => AppColors.shade.black26;
  Color get shadeBlack54 => AppColors.shade.black54;
  Color get shadeBlack87 => AppColors.shade.black87;
  Color get shadeWhite05 => AppColors.shade.white05;
  Color get shadeWhite12 => AppColors.shade.white12;
  Color get shadeWhite26 => AppColors.shade.white26;
  Color get shadeWhite54 => AppColors.shade.white54;
  Color get shadeWhite87 => AppColors.shade.white87;
}

String truncateString(String text, {int maxLength = 13}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}...';
  }
}
