import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/resources/theme/app_colors.dart';

class AdminButton extends StatelessWidget {
  const AdminButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brand.primary,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      label: Text(label),
      icon: Icon(icon),
    );
  }
}
