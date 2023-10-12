import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/views/exam_view.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/widget/exam_details_row.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/extensions/int_extensions.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamDetailsView extends StatefulWidget {
  const ExamDetailsView({
  required this.exam
  ,super.key,});
  static const route = '/exam-details';
  final Exam exam;

  @override
  State<ExamDetailsView> createState() => _ExamDetailsViewState();
}

class _ExamDetailsViewState extends State<ExamDetailsView> {

  late Exam completeExam;

  void getQuestions(){
    context.read<ExamCubit>().getExamQuestions(widget.exam);
  }

  @override
  void initState() {
    completeExam = widget.exam;
    super.initState();
    getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam.title),
        leading: const NestedBackButton(),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colours.physicsTileColour,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child:
                        (widget.exam.imageUrl != null)?
                            Image.network(widget.exam.imageUrl!,
                            height: 60,
                            width: 60,
                              fit: BoxFit.cover,
                            ):
                        Image.asset(MediaRes.test,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(widget.exam.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    ),
                  ],
                ),
            ),
            const SizedBox(height: 10,),
            Text(
              widget.exam.description,
              style: const TextStyle(color: Colours.neutralTextColour,
              fontSize: 14
              ,),
            ),
            const SizedBox(height: 10,),
            ExamDetailsRow(
              title: '${widget.exam.timeLimit.displayDurationLong} for the test'
              , subTitle: 'Complete the test in '
                  '${widget.exam.timeLimit.displayDurationLong}',
              icon: MediaRes.examTime,
            ),
            const SizedBox(height: 10,),
            ExamDetailsRow(
              title: '${widget.exam.examQuestions!.length} Questions',
              subTitle: 'this test consists of '
                  '${widget.exam.examQuestions!.length} Questions',
              icon: MediaRes.courseInfoExam,
            ),
            const Spacer(),
            ElevatedButton(
            style: ElevatedButton.styleFrom(
            backgroundColor: Colours.primaryColour,
                foregroundColor: Colors.white,
            ),onPressed: (){
            Navigator.pushNamed(context, ExamView.route,);
            },
                child: const Text('Start Exam',),),

          ],

        ),
      ),


    );
  }
}
