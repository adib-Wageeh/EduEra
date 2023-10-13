import 'package:education_app/core/common/features/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/app/providers/exams_controller.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/widget/exam_navigation_blob.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ExamView extends StatefulWidget {
  const ExamView({super.key});
  static const route = '/exam-view';

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> {

  bool loading = false;
  late ExamController examController;

  Future<void> submitExam()async{
    if (!examController.isTimeUp) {
      examController.stopTimer();
      final isMinutesLeft = examController.remainingTimeInSeconds > 60;
      final isHoursLeft = examController.remainingTimeInSeconds > 3600;
      final timeLeftText = isHoursLeft
          ? 'hours'
          : isMinutesLeft
          ? 'minutes'
          : 'seconds';
      final endExam = await showDialog<bool>
        (context: context, builder: (context) {
        return AlertDialog(
          title: const Text('Submit Exam?'),
          content: Text(
            'You have ${examController.remainingTime} $timeLeftText left.\n'
                'Are you sure you want to submit?',
          ),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context, false);
            }, child: const Text('Cancel'),),
            TextButton(onPressed: () {
              Navigator.pop(context, true);
            }, child: const Text('Submit exam',
            style: TextStyle(
              color: Colours.redColour,
            ),
            ),),
          ],
        );
      },);
      if (endExam ?? false) {
        return collectAndSend();
      } else {
        examController.startTimer();
        return;
      }
    }
    collectAndSend();

  }


  void collectAndSend() {
    final exam = examController.userExam;
    context.read<ExamCubit>().submitExam(exam);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    examController = context.read<ExamController>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      examController.addListener(() {
        if(examController.isTimeUp) submitExam();
      });
    });
  }

  @override
  void dispose() {
    examController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamController>(builder: (_,controller,__){
        return BlocConsumer<ExamCubit,ExamState>(listener: (context,state){
          if(loading){
            loading = false;
            Navigator.pop(context);
          }
          if(state is ExamError){
            CoreUtils.showSnackBar(context, state.message);
          }else if(state is SubmittingExam){
            loading = true;
            CoreUtils.showLoadingDialog(context);
          }else if(state is ExamSubmitted){
            CoreUtils.showSnackBar(context, 'Exam submitted successfully');
            Navigator.pop(context);
          }

        },
          builder: (context,state){
          return WillPopScope(child:
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(MediaRes.examTimeRed,
                    width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 10,),
                    Text(controller.remainingTime,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colours.redColour,
                    ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(onPressed: submitExam, child:
                  const Text('Submit',style: TextStyle(fontSize: 16),),),
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Expanded(child: ListView(
                        children: [
                          Text(
                            'Question ${controller.currentIndex + 1}',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color(0xFF666E7A),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            controller.currentQuestion.questionText,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                            controller.currentQuestion.choices.length,
                            itemBuilder: (_, index) {
                              final choice =
                              controller.currentQuestion.choices[index];
                              return RadioListTile(
                                value: choice.identifier,
                                contentPadding: EdgeInsets.zero,
                                groupValue: controller.userAnswer?.userChoice,
                                title: Text(
                                  '${choice.identifier}. '
                                      '${choice.choiceAnswer}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onChanged: (value) {
                                  controller.answer(choice);
                                },
                              );
                            },
                          ),
                        ],
                      ),),
                      const ExamNavigationBlob(),
                    ],
                  ),
                ),
              ),
            ), onWillPop: ()async{
              if(state is SubmittingExam) return false;
              if(controller.isTimeUp) return true;
              final result = await showDialog<bool>
                (context: context, builder: (context){
                  return  AlertDialog(
                    title: const Text('Exit exam'),
                    content: const
                    Text('Are you sure you want to exit the exam'),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context,false);
                      }, child: const Text('Cancel'),),
                      TextButton(onPressed: (){
                        Navigator.pop(context,true);
                      }, child: const Text('Exit exam'),),
                    ],
                  );
              },);
              return result ?? false;
          },);
          },
        );
    },);
  }
}
