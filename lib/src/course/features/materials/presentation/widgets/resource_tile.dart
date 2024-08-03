import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:pacola_quiz/core/resources/theme/app_colors.dart';
import 'package:pacola_quiz/src/course/features/materials/presentation/app/providers/resource_controller.dart';
import 'package:provider/provider.dart';

class ResourceTile extends StatelessWidget {
  const ResourceTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResourceController>(
      builder: (_, controller, __) {
        final resource = controller.resource!;

        final descriptionIsNull =
            resource.description == null || resource.description!.isEmpty;

        final downloadButton = controller.downloading
            ? CircularProgressIndicator(
                value: controller.percentage,
                color: AppColors.brand.primary,
              )
            : IconButton.filled(
                onPressed: controller.fileExists
                    ? controller.openFile
                    : controller.downloadAndSaveFile,
                icon: Icon(
                  controller.fileExists
                      ? Icons.folder_open_sharp
                      : Icons.download_rounded,
                ),
              );
        return ExpansionTile(
          tilePadding: EdgeInsets.zero,
          expandedAlignment: Alignment.centerLeft,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
          leading: FileIcon('.${resource.fileExtension}', size: 40),
          title: Text(
            resource.title!,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                downloadButton,
                if (!descriptionIsNull)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(resource.description!),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
