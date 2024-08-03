import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacola_quiz/core/common/widgets/course_picker.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';
import 'package:pacola_quiz/core/resources/media_resources.dart';
import 'package:pacola_quiz/core/utils/core_utils.dart';
import 'package:pacola_quiz/core/utils/typedefs.dart';
import 'package:pacola_quiz/src/course/domain/entities/course.dart';
import 'package:pacola_quiz/src/course/features/quizzes/data/models/quiz_model.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/app/cubit/quiz_cubit.dart';
import 'package:pacola_quiz/src/course/features/quizzes/presentation/app/cubit/quiz_state.dart';

class AddQuizView extends StatefulWidget {
  const AddQuizView({super.key});

  static const routeName = '/add-exam';

  @override
  State<AddQuizView> createState() => _AddQuizViewState();
}

class _AddQuizViewState extends State<AddQuizView> {
  File? examFile;

  final formKey = GlobalKey<FormState>();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  Future<void> pickQuizFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null) {
      setState(() {
        examFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadQuiz() async {
    if (examFile == null) {
      return CoreUtils.showSnackBar(context, 'Please pick an exam to upload');
    }
    if (formKey.currentState!.validate()) {
      final json = examFile!.readAsStringSync();
      final jsonMap = jsonDecode(json) as DataMap;
      final quiz = QuizModel.fromUploadMap(jsonMap).copyWith(
        courseId: courseNotifier.value!.id,
        createdBy: context.userProvider.user?.id,
      );
      await context.read<QuizCubit>().uploadQuiz(quiz);
    }
  }

  bool showingDialog = false;

  @override
  void dispose() {
    courseController.dispose();
    courseNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizCubit, QuizState>(
      listener: (_, state) {
        if (showingDialog == true) {
          Navigator.pop(context);
          showingDialog = false;
        }
        if (state is UploadingQuiz) {
          CoreUtils.showLoadingDialog(context);
          showingDialog = true;
        } else if (state is QuizError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is QuizUploaded) {
          CoreUtils.showSnackBar(context, 'Quiz uploaded successfully');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Add Quiz')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: CoursePicker(
                      controller: courseController,
                      notifier: courseNotifier,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (examFile != null) ...[
                    const SizedBox(height: 10),
                    Card(
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Image.asset(MediaRes.json),
                        ),
                        title: Text(examFile!.path.split('/').last),
                        trailing: IconButton(
                          onPressed: () => setState(() {
                            examFile = null;
                          }),
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: pickQuizFile,
                        child: Text(
                          examFile == null
                              ? 'Select Quiz File'
                              : 'Replace Quiz File',
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: uploadQuiz,
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
