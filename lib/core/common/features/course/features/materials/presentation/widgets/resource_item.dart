import 'package:education_app/core/common/features/course/features/materials/presentation/app/providers/resouce_controller.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResourceItem extends StatefulWidget {
  const ResourceItem({
  super.key,});

  @override
  State<ResourceItem> createState() => _ResourceItemState();
}

class _ResourceItemState extends State<ResourceItem> {

  bool isOpened = false;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Consumer<ResourceController>(
        builder: (_,controller,__){
          final resource = controller.getResource!;
          final authorIsNull =
              resource.author == null || resource.author!.isEmpty;
          final descriptionIsNull =
              resource.description == null || resource.description!.isEmpty;
          final downloadButton = controller.getDownloading
              ? CircularProgressIndicator(
            value: controller.getPercentage,
            color: Colours.primaryColour,
          )
              : IconButton.filled(
            onPressed: controller.fileExists
                ? controller.openFile
                : controller.downloadAndSave,
            icon: Icon(
              controller.fileExists
                  ? Icons.download_done_rounded
                  : Icons.download_rounded,
            ),
          );

          return ExpansionTile(
            leading: FileIcon('.${resource.fileExtension}',
            size: 40,),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
            title: Text(
              maxLines: 2,
              resource.title!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            expandedAlignment: Alignment.centerLeft,
            tilePadding: EdgeInsets.zero,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (authorIsNull && descriptionIsNull) downloadButton,
                  if (!authorIsNull)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Author',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(resource.author!),
                            ],
                          ),
                        ),
                        downloadButton,
                      ],
                    ),
                  if (!descriptionIsNull)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!authorIsNull) const SizedBox(height: 10),
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
                        if (authorIsNull) downloadButton,
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
