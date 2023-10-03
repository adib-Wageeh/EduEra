import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/features/materials/data/models/materials_model.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/entities/materials.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/entities/picked_resource.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/app/cubit/resource_cubit.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/widgets/edit_resource_dialog.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/widgets/picked_resource_tile.dart';
import 'package:education_app/core/common/widgets/course_picker.dart';
import 'package:education_app/core/common/widgets/information_field.dart';
import 'package:education_app/core/enums/notification.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/extensions/int_extensions.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/notification/presentation/widgets/notification_wrapper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AddMaterialsView extends StatefulWidget {
  const AddMaterialsView({super.key});

  static const route = '/add-materials';

  @override
  State<AddMaterialsView> createState() => _AddMaterialsViewState();
}

class _AddMaterialsViewState extends State<AddMaterialsView> {

  final formKey = GlobalKey<FormState>();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);
  final authorController = TextEditingController();
  bool authorSet = false;
  List<PickedResource> resources = <PickedResource>[];

  Future<void> pickResources() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        resources.addAll(
          result.paths.map(
                (path) => PickedResource(
              path: path!,
              author: authorController.text.trim(),
              title: path.split('/').last,
            ),
          ),
        );
      });
    }
  }

  Future<void> editResource(int resourceIndex) async {
    final resource = resources[resourceIndex];
    final newResource = await showDialog<PickedResource>(
      context: context,
      builder: (_) => EditResourceDialog(resource),
    );
    if (newResource != null) {
      setState(() {
        resources[resourceIndex] = newResource;
      });
    }
  }

  void setAuthor(){
    if (authorSet) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final newResources = <PickedResource>[];
    for (final resource in resources) {
      var newResource = resource;
      if(!resource.authorManuallySet) {
        newResource = resource.copyWith(
          author: authorController.text.trim(),
        );
      }
      newResources.add(newResource);
    }
    setState(() {
      resources = newResources;
      authorSet = true;
    });

  }

  void uploadMaterials() {
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
      final resources = <Resources>[];
      for (final resource in this.resources) {
        resources.add(
          ResourcesModel.empty().copyWith(
            courseId: courseNotifier.value!.id,
            url: resource.path,
            title: resource.title,
            description: resource.description,
            author: resource.author,
            fileExtension: resource.path.split('.').last,
          ),
        );
      }
      context.read<ResourceCubit>().addResources(resources);
    }
  }

  @override
  void dispose() {
    courseNotifier.dispose();
    courseController.dispose();
    authorController.dispose();
    super.dispose();
  }

  bool showingLoader = false;

  @override
  Widget build(BuildContext context) {
    return NotificationWrapper(
      onNotificationSent: () {
        Navigator.pop(context);
      },
      child: BlocListener<ResourceCubit, ResourceState>(
  listener: (context, state) {
      if (showingLoader) {
        Navigator.pop(context);
        showingLoader = false;
      }
      if (state is ResourceError) {
        CoreUtils.showSnackBar(context, state.message);
      } else if (state is ResourceAdded) {
        CoreUtils.showSnackBar(
          context,
          'Material(s) uploaded successfully',
        );
        CoreUtils.sendNotification(
          'New ${courseNotifier.value!.title} '
              'Material${resources.length.pluralize}',
         'A new material has been '
              'uploaded for ${courseNotifier.value!.title}',
           NotificationCategory.MATERIAL,
          context,
        );
      } else if(state is AddingResource) {
        CoreUtils.showLoadingDialog(context);
        showingLoader = true;
      }
  },
  child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Add Materials')),
        body: SafeArea(
          child: Padding(padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: CoursePicker(
                    controller: courseController,
                    courseNotifier: courseNotifier,
                  ),
                ),
                const SizedBox(height: 10,),
                InfoField(
                  controller: authorController,
                  hintText: 'General Author',
                  onChanged: (text){
                    if(authorSet){
                      setState(() {
                        authorSet = false;
                      });
                    }
                  },
                  suffixIcon: IconButton(onPressed: setAuthor,
                      icon: Icon(
                        authorSet? Icons.check_circle:Icons.check_circle,
                        color: authorSet? Colors.green:Colors.grey,
                      ),),
                ),
                const SizedBox(height: 10,),
                Text(
                  'You can upload multiple materials at once.',
                  style: context.getTheme.textTheme.bodySmall?.copyWith(
                    color: Colours.neutralTextColour,
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
                          onEdit: () => editResource(index),
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
                      child: const Text('Add Materials'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: uploadMaterials,
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
),
    );
  }
}
