import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pacola_quiz/core/common/widgets/custom_form_builder_text_field.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';

class CustomFormBuilderTitledTextField extends StatelessWidget {
  const CustomFormBuilderTitledTextField({
    required this.title,
    required this.name,
    this.required = true,
    this.border,
    this.controller,
    this.filled = true,
    this.obscureText = false,
    this.readOnly = false,
    super.key,
    this.validators,
    this.fillColour,
    this.suffixIcon,
    this.hintText,
    this.keyboardType,
    this.hintStyle,
    this.onTap,
    this.focusNode,
    this.enabled,
    this.maxLines = 1,
  });

  final bool required;
  final String title;
  final String name;
  final bool? enabled;
  final InputBorder? border;
  final List<String? Function(String?)>? validators;
  final TextEditingController? controller;
  final bool filled;
  final Color? fillColour;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextStyle? hintStyle;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                text: title,
                style: context.theme.textTheme.titleMedium,
                children: required
                    ? [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                      ]
                    : null,
              ),
            ),
            if (suffixIcon != null) suffixIcon!,
          ],
        ),
        const SizedBox(height: 8),
        CustomFormBuilderTextField(
          maxLines: maxLines,
          name: name,
          hintText: hintText ?? 'Enter $title',
          hintStyle: hintStyle,
          validator: FormBuilderValidators.compose([
            if (required)
              (value) {
                if (value == null || value.isEmpty) {
                  return '$title is required';
                }
                return null;
              },
            if (validators != null) ...validators!,
          ]),
          filled: filled,
          fillColour: fillColour,
          border: border,
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          keyboardType: keyboardType,
          onTap: onTap,
          focusNode: focusNode,
          enabled: enabled,
        ),
      ],
    );
  }
}
