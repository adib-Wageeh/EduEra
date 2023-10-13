import 'package:education_app/core/common/features/course/features/exams/data/models/exam_model.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/views/exam_view.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/widget/exam_details_row.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/extensions/int_extensions.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamDetailsView extends StatefulWidget {
  const ExamDetailsView({
    required this.exam
    , super.key,});

  static const route = '/exam-details';
  final Exam exam;

  @override
  State<ExamDetailsView> createState() => _ExamDetailsViewState();
}

class _ExamDetailsViewState extends State<ExamDetailsView> {

  late Exam completeExam;

  void getQuestions() {
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
      body: BlocConsumer<ExamCubit, ExamState>(
        listener: (context, state) {
          if (state is ExamError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is ExamQuestionsLoaded) {
            completeExam = (completeExam as ExamModel).copyWith(
              questions: state.questions,
            );
          }
        },
        builder: (context, state) {
          return Padding(
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
                          (completeExam.imageUrl != null
                              && completeExam.imageUrl!.isNotEmpty) ?
                          Image.network(completeExam.imageUrl!,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ) :
                          Image.asset(MediaRes.test,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(completeExam.title,
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
                  completeExam.description,
                  style: const TextStyle(color: Colours.neutralTextColour,
                    fontSize: 14
                    ,),
                ),
                const SizedBox(height: 10,),
                ExamDetailsRow(
                  title: '${completeExam.timeLimit
                      .displayDurationLong} for the test'
                  , subTitle: 'Complete the test in '
                    '${completeExam.timeLimit.displayDurationLong}',
                  icon: MediaRes.examTime,
                ),
                const SizedBox(height: 10,),
                ExamDetailsRow(
                  title: '${completeExam.examQuestions!.length} Questions',
                  subTitle: 'this test consists of '
                      '${completeExam.examQuestions!.length} Questions',
                  icon: MediaRes.courseInfoExam,
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colours.primaryColour,
                    foregroundColor: Colors.white,
                  ), onPressed: () {
                  Navigator.pushNamed(context, ExamView.route,
                  arguments: completeExam,
                  );
                },
                  child: const Text('Start Exam',),),

              ],

            ),
          );
        },
      ),


    );
  }
}
