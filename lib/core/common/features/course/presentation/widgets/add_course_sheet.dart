import 'dart:io';
import 'package:education_app/core/common/features/course/data/models/course_model.dart';
import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/core/common/widgets/titled_input_field.dart';
import 'package:education_app/core/enums/notification.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/notification/presentation/widgets/notification_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCourseSheet extends StatefulWidget {
  const AddCourseSheet({super.key});

  @override
  State<AddCourseSheet> createState() => _AddCourseSheetState();
}

class _AddCourseSheetState extends State<AddCourseSheet> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  File? image;

  bool isFile = false;
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    imageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    imageController.addListener(() {

      if(isFile && imageController.text.trim().isEmpty){
        image = null;
        isFile = false;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return NotificationWrapper(
      onNotificationSent: (){
        if(loading){
          Navigator.of(context).pop();
        }
        Navigator.of(context).pop();
      },
  child: BlocListener<CourseCubit,CourseState>(
        listener: (_,state){
          if(loading) {
            loading = false;
            Navigator.pop(context);
          }
            if(state is CourseError){
              Navigator.pop(context);
              CoreUtils.showSnackBar(context,
              state.message,);
            }else if(state is AddingCourse){
              loading = true;
              CoreUtils.showLoadingDialog(context);
            }else if(state is CourseAdded){
              CoreUtils.showSnackBar
                (context, 'Course added successfully',);
              CoreUtils.sendNotification(
                  'New Course ${titleController.text.trim()}',
                  'A new course has been added',
                  NotificationCategory.COURSE,context,);
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
        child:
        Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children:  [
              const Text('Add course',
              style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.bold,
              ),
              ),
              const SizedBox(height: 20,),
              TitledInputField(
                title: 'Course title',
                controller: titleController,
              ),
              const SizedBox(height: 20,),
              TitledInputField(
                title: 'Description',
                controller: descriptionController,
                required: false,
              ),
              const SizedBox(height: 20,),
              TitledInputField(
                title: 'Course Image',
                controller: imageController,
                required: false,
                hintText: 'Enter image url or pick from gallery',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                suffixIcon: IconButton(onPressed: ()
                async{
                  final image = await CoreUtils.pickImage();
                  if(image != null){
                    isFile = true;
                    this.image = image;
                    final imageName = image.path.split('/').last;
                      imageController.text = imageName;
                  }
                }, icon: const Icon(Icons.add_photo_alternate_outlined),),
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child:
                  ElevatedButton(
                    child: const Text('Add'),
                    onPressed: (){
                      if(formKey.currentState!.validate()){
                        final now =DateTime.now();
                        final Course course = CourseModel.empty()
                        .copyWith(createdAt: now,
                          image: isFile? image!.path :
                          imageController.text.trim()
                          ,
                        imageAsFile: isFile,
                        updatedAt: now,
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),);

                        context.read<CourseCubit>().addCourse(course);
                      }
                    },
                  ),
                  ),
                  const SizedBox(height: 20,),
                  Expanded(child: ElevatedButton(
                      onPressed: ()=>Navigator.pop(context),
                      child: const Text('Cancel'),),),
                ],
              ),
            ],
          ),
        )
        ,
      ),
    ),
    ),
);
  }
}
