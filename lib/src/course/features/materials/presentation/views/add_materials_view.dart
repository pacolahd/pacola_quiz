import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide MaterialState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacola_quiz/core/common/widgets/course_picker.dart';
import 'package:pacola_quiz/core/extensions/context_extensions.dart';
import 'package:pacola_quiz/core/utils/core_utils.dart';
import 'package:pacola_quiz/src/course/domain/entities/course.dart';
import 'package:pacola_quiz/src/course/features/materials/data/models/resource_model.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/entities/material.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/entities/picked_resource.dart';
import 'package:pacola_quiz/src/course/features/materials/presentation/app/cubit/material_cubit.dart';
import 'package:pacola_quiz/src/course/features/materials/presentation/widgets/edit_resource_dialog.dart';
import 'package:pacola_quiz/src/course/features/materials/presentation/widgets/picked_resource_tile.dart';

class AddMaterialsView extends StatefulWidget {
  const AddMaterialsView({super.key});

  static const routeName = '/add-materials';

  @override
  State<AddMaterialsView> createState() => _AddAddMaterialsViewViewState();
}

class _AddAddMaterialsViewViewState extends State<AddMaterialsView> {
  List<PickedResource> resources = <PickedResource>[];

  final formKey = GlobalKey<FormState>();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);
  final authorController = TextEditingController();

  bool authorSet = false;

  Future<void> pickResources() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        resources.addAll(
          result.paths.map(
            (path) => PickedResource(
              path: path!,
              title: path.split('/').last,
            ),
          ),
        );
      });
    }
  }

  Future<void> editresource(int resourceIndex) async {
    final resource = resources[resourceIndex];
    final newresource = await showDialog<PickedResource>(
      context: context,
      builder: (_) => EditResourceDialog(resource),
    );
    if (newresource != null) {
      setState(() {
        resources[resourceIndex] = newresource;
      });
    }
  }

  void uploadresources() {
    if (formKey.currentState!.validate()) {
      if (this.resources.isEmpty) {
        return CoreUtils.showSnackBar(context, 'No resources picked yet');
      }
      if (!authorSet && authorController.text.trim().isNotEmpty) {
        return CoreUtils.showSnackBar(
          context,
          'Please tap on the check icon in '
          'the author field to confirm the author',
        );
      }

      final resources = <Resource>[];
      for (final resource in this.resources) {
        resources.add(
          ResourceModel.empty().copyWith(
            courseId: courseNotifier.value!.id,
            fileURL: resource.path,
            title: resource.title,
            description: resource.description,
            fileExtension: resource.path.split('.').last,
          ),
        );
      }
      context.read<MaterialCubit>().addMaterials(resources);
    }
  }

  bool showingLoader = false;

  @override
  void dispose() {
    courseController.dispose();
    courseNotifier.dispose();
    authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MaterialCubit, MaterialState>(
      listener: (context, state) {
        if (showingLoader) {
          Navigator.pop(context);
          showingLoader = false;
        }
        if (state is MaterialError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is MaterialsAdded) {
          CoreUtils.showSnackBar(
            context,
            'resource(s) uploaded successfully',
          );
        } else if (state is AddingMaterials) {
          CoreUtils.showLoadingDialog(context);
          showingLoader = true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Add resources')),
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
                  const SizedBox(height: 10),
                  Text(
                    'You can upload multiple materials at once.',
                    style: context.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (resources.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: resources.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (_, index) {
                          final resource = resources[index];
                          return PickedResourceTile(
                            resource,
                            onEdit: () => editresource(index),
                            onDelete: () {
                              setState(() {
                                resources.removeAt(index);
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: pickResources,
                        child: const Text('Add resources'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: uploadresources,
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
