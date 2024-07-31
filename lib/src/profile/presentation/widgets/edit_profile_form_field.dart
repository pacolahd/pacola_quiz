import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/common/widgets/custom_form_builder_text_field.dart';

class EditProfileFormField extends StatelessWidget {
  const EditProfileFormField({
    required this.name,
    required this.fieldTitle,
    required this.controller,
    super.key,
    this.hintText,
    this.readOnly = false,
  });

  final String name;
  final String fieldTitle;
  final TextEditingController controller;
  final String? hintText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            fieldTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(height: 10),
        CustomFormBuilderTextField(
          name: name,
          controller: controller,
          hintText: hintText,
          readOnly: readOnly,
        ),
        // IField(
        //   controller: controller,
        //   hintText: hintText,
        //   readOnly: readOnly,
        // ),
        const SizedBox(height: 30),
      ],
    );
  }
}
