import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pacola_quiz/core/common/widgets/custom_form_builder_titled_text_field.dart';
import 'package:pacola_quiz/core/utils/core_utils.dart';
import 'package:pacola_quiz/src/course/data/models/course_model.dart';
import 'package:pacola_quiz/src/course/presentation/bloc/course_cubit.dart';
import 'package:pacola_quiz/src/course/presentation/bloc/course_state.dart';

class AddCourseSheet extends StatefulWidget {
  const AddCourseSheet({super.key});

  @override
  State<AddCourseSheet> createState() => _AddCourseSheetState();
}

class _AddCourseSheetState extends State<AddCourseSheet> {
  final _formKey = GlobalKey<FormBuilderState>();
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _formKey.currentState?.fields['course_image']
          ?.didChange(pickedFile.path.split('/').last);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseCubit, CourseState>(
      listener: (context, state) {
        if (state is CourseError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is CourseAdded) {
          CoreUtils.showSnackBar(context, 'Course added successfully');
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: FormBuilder(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  'Add Course',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CustomFormBuilderTitledTextField(
                  name: 'title',
                  title: 'Course Title',
                  validators: [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(3),
                  ],
                ),
                const SizedBox(height: 20),
                const CustomFormBuilderTitledTextField(
                  name: 'description',
                  title: 'Description',
                  required: false,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                CustomFormBuilderTitledTextField(
                  name: 'course_image',
                  title: 'Course Image',
                  required: false,
                  hintText: 'Pick an image from gallery',
                  readOnly: true,
                  suffixIcon: IconButton(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library),
                  ),
                ),
                if (_image != null) ...[
                  const SizedBox(height: 10),
                  Text('Selected image: ${_image!.path.split('/').last}'),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.saveAndValidate()) {
                            final formData = _formKey.currentState!.value;
                            final now = DateTime.now();
                            final course = CourseModel.empty().copyWith(
                              title: formData['title'] as String,
                              description: formData['description'] as String?,
                              image: _image?.path,
                              createdAt: now,
                              updatedAt: now,
                            );
                            context.read<CourseCubit>().addCourse(course);
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
