import 'dart:convert';
import 'dart:io';
import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/features/exams/data/models/exam_model.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:education_app/core/common/widgets/course_picker.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/enums/notification.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/notification/presentation/widgets/notification_wrapper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExamView extends StatefulWidget {
  const AddExamView({super.key});

  static const route = '/add-exam';

  @override
  State<AddExamView> createState() => _AddExamViewState();
}

class _AddExamViewState extends State<AddExamView> {

  final formKey = GlobalKey<FormState>();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);
  File? examFile;
  bool loading = false;

  Future<void> pickExamFile()async{

    final files = await FilePicker.platform.pickFiles();
    if(files != null){
      setState(() {
        examFile = File(files.paths.first!);
      });
    }
  }

  Future<void> uploadExam()async{
    if(examFile == null){
      return CoreUtils.showSnackBar(context, 'please pick an exam file');
    }
    if(formKey.currentState!.validate()){
      final json = examFile!.readAsStringSync();
      final jsonMap = jsonDecode(json) as DataMap;
      final exam = ExamModel.fromUploadMap(jsonMap)
      .copyWith(
        courseId: courseNotifier.value!.id,
      );
      await context.read<ExamCubit>().uploadExam(exam);
    }

  }

  @override
  void dispose() {
    courseController.dispose();
    courseNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationWrapper(onNotificationSent: (){
      Navigator.of(context).pop();
    }
    , child: BlocListener<ExamCubit,ExamState>(
          listener: (context,state){
            if(loading){
              loading = false;
              Navigator.of(context).pop();
            }
            if(state is ExamError){
              CoreUtils.showSnackBar(context, state.message);
            }else if(state is UploadingExam){
              loading = true;
              CoreUtils.showLoadingDialog(context);
            }else if(state is ExamUploaded){
              CoreUtils.showSnackBar(context, 'Exam added successfully');
              CoreUtils.sendNotification(
                  'New Exam has been added !!',
                  ' new exam in ${courseNotifier.value!.title}',
                  NotificationCategory.TEST, context,);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              leading: const NestedBackButton(),
              title: const Text('Add Exam'),
            ),
            backgroundColor: Colors.white,
            body: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              children: [
                Form(
                  key: formKey,
                  child: CoursePicker(controller: courseController,
                    courseNotifier: courseNotifier,),
                ),
                const SizedBox(
                  height: 10,
                ),
                if(examFile != null)...[
                  const SizedBox(height: 10,),
                  Card(
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Image.asset(MediaRes.json),
                      ),
                      title: Text(examFile!.path.split('/').last),
                      trailing: IconButton(
                        onPressed: (){
                            setState(() {
                              examFile = null;
                            });
                        },
                        icon: const Icon(
                          Icons.close,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                ],
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: pickExamFile,
                      child: Text(
                        examFile == null ? 'Add exam':'Replace exam file',
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: uploadExam,
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

    );
  }
}
