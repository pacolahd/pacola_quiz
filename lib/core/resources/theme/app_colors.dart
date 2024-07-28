import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const brand = _Brand();
  static const accent = _Accent();
  static const background = _Background();
  static const textColor = _TextColor();
  static const feedback = _Feedback();
  static const ui = _UI();
  static const overlay = _Overlay();
  static const shade = _Shade();

  static final MaterialColor primarySwatch =
      _createMaterialColor(brand.primary);
  static final MaterialColor secondarySwatch =
      _createMaterialColor(brand.secondary);

  static MaterialColor _createMaterialColor(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final r = color.red;
    final g = color.green;
    final b = color.blue;

    for (var i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final strength in strengths) {
      final ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }

  static Color darken(Color color, [double amount = .1]) {
    assert(
      amount >= 0 && amount <= 1,
      'Amount must be between 0 and 1',
    );
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(
      amount >= 0 && amount <= 1,
      'Amount must be between 0 and 1',
    );
    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}

class _Brand {
  const _Brand();

  Color get primary => const Color(0xFF3498DB);
  Color get primaryLight => const Color(0xFF5DADE2);
  Color get primaryDark => const Color(0xFF2980B9);
  Color get secondary => const Color(0xFF2ECC71);
  Color get secondaryLight => const Color(0xFF58D68D);
  Color get secondaryDark => const Color(0xFF27AE60);
}

class _Accent {
  const _Accent();

  Color get orange => const Color(0xFFF39C12);
  Color get purple => const Color(0xFF9B59B6);
  Color get red => const Color(0xFFE74C3C);
}

class _Background {
  const _Background();

  Color get main => const Color(0xFFF5F5F5);
  Color get surface => Colors.white;
  Color get card => Colors.white;
}

class _TextColor {
  const _TextColor();

  Color get primary => const Color(0xFF333333);
  Color get secondary => const Color(0xFF757575);
  Color get hint => const Color(0xFF9E9E9E);
  Color get disabled => const Color(0xFFBDBDBD);
  Color get link => const Color(0xFF2196F3);
  Color get inversePrimary => Colors.white;
  Color get inverseSecondary => const Color(0xB3FFFFFF);
}

class _Feedback {
  const _Feedback();

  Color get success => const Color(0xFF2ECC71);
  Color get error => const Color(0xFFE74C3C);
  Color get warning => const Color(0xFFF1C40F);
  Color get info => const Color(0xFF3498DB);
}

class _UI {
  const _UI();

  Color get divider => const Color(0xFFBDBDBD);
  Color get border => const Color(0xFFE0E0E0);
  Color get iconPrimary => const Color(0xFF757575);
  Color get iconSecondary => const Color(0xFF9E9E9E);
  Color get disabled => const Color(0xFFBDBDBD);
}

class _Overlay {
  const _Overlay();

  Color get light => const Color(0x0A000000);
  Color get dark => const Color(0x99000000);
}

class _Shade {
  const _Shade();

  Color get black05 => const Color(0x0D000000);
  Color get black12 => const Color(0x1F000000);
  Color get black26 => const Color(0x42000000);
  Color get black54 => const Color(0x8A000000);
  Color get black87 => const Color(0xDD000000);
  Color get white05 => const Color(0x0DFFFFFF);
  Color get white12 => const Color(0x1FFFFFFF);
  Color get white26 => const Color(0x42FFFFFF);
  Color get white54 => const Color(0x8AFFFFFF);
  Color get white87 => const Color(0xDDFFFFFF);
}
